class TrainsController < ApplicationController

  before_action :authenticate_user!, only: [:post_slack, :delete_slack]

  def index

    # 検索失敗時に表示するためのstring型変数
    @failure_comment = ""

    # サービスクラスGetTrainInformationServiceから鉄道運行情報を取得
    @information_list = GetTrainInformationService.fetch

  end

  def search

    @failure_comment = ""

    # route
    departure = params[:departure]
    destination = params[:destination]
    @datetime = params[:datetime]
    departure_flag = params[:departure_flag].to_i

    # 経路検索フォームに空欄が合った場合にindexビューに戻る
    if (destination.nil? || departure.empty?) || (destination.nil? || destination.empty?) || @datetime.nil?
      
      @failure_comment = "全ての項目を入力してください。"
      @information_list = GetTrainInformationService.fetch
      render template: "trains/index"
    
    else

      # サービスクラスSearchNavitimeRoutesServiceから条件を満たす最適なルートを取得
      # @route_result = SearchNavitimeRoutesService.fetch(departure, destination, @datetime, departure_flag)

      # NAVITIME APIのコール回数削減のために経路検索結果をdumpしたものです。特に不要な場合はこちらのメソッドで読込してください。
      # 直通か非直通かでそれぞれjsonファイルが違うので、目的に合わせてコメントアウトを外してください。

      file_name = Rails.public_path.join("jsons", "response_sample_no_transit.json") # 所沢→渋谷の直通経路のレスポンス
      # file_name = Rails.public_path.join("jsons", "response_sample.json") # 西国分寺→渋谷の乗換有のレスポンス
      @route_result = SearchNavitimeRoutesService.sample_fetch(file_name)

      train_information = FetchTrainsApisService.fetch(FetchTrainsApisService.apis[:ti])
      railways = FetchTrainsApisService.fetch(FetchTrainsApisService.apis[:r])
      train_information.each do |train_info|
        puts train_info["odpt:railway"]
        railways.each do |railway|
          if train_info["odpt:railway"] == railway["owl:sameAs"]
            puts railway["dc:title"]
          end
        end
      end
    
      # 例外処理が実行されていればtrains/indexにrender
      if @route_result.is_a?(String)

        @failure_comment = HandleExceptionService.update_comment(@route_result)

        @information_list = GetTrainInformationService.fetch
        render template: "trains/index"

      else
        
        # 経路検索結果に引き渡すBookmarkモデルのインスタンス変数
        if user_signed_in?
        
          @bookmark = Bookmark.new(departure: departure, destination: destination, time: @datetime.to_datetime.strftime("%H:%M"), departure_flag: departure_flag, status_check: true)
          @parameters = {
            bookmark: {
              name: "#{@bookmark.departure}→#{@bookmark.destination}",
              departure: @bookmark.departure,
              destination: @bookmark.destination,
              time: @bookmark.time,
              departure_flag: @bookmark.departure_flag,
              status_check: false,
            },
            datetime: @datetime.to_datetime
          }

        end

      end

    end
    
  end

  def sandbox

  end

  def post_slack

    params[:times].each do |time|

      if DateTime.now < Time.at(time.to_i)
        PostSlackReminderService.post_reminder(current_user, time)
      end

    end

  end

  def delete_slack

    params[:times].each do |time|

      if DateTime.now < Time.at(time.to_i)
        PostSlackReminderService.delete_reminder(current_user, time)
      end

    end

  end

  private

end
