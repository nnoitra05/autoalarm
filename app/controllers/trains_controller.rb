class TrainsController < ApplicationController

  def index

    # サービスクラスGetTrainInformationServiceから鉄道運行情報を取得
    @information_list = GetTrainInformationService.fetch

    # indexアクションを発生させた時刻を取得
    @dt = DateTime.now

  end

  def search

    # route
    departure = params[:departure]
    destination = params[:destination]
    time = params[:arrival_at]
    departure_flag = params[:departure_flag].to_i

    # サービスクラスSearchNavitimeRoutesServiceから条件を満たす最適なルートを取得
    # route_result = SearchNavitimeRoutesService.fetch(departure, destination, time, departure_flag)

    # NAVITIME APIのコール回数削減のために経路検索結果をdumpしたものです。特に不要な場合はこちらのメソッドで読込してください。
    # 直通か非直通かでそれぞれjsonファイルが違うので、目的に合わせてコメントアウトを外してください。
    # file_name = Rails.public_path.join("jsons", "response_sample_no_transit.json") # 所沢→渋谷の直通経路のレスポンス
    file_name = Rails.public_path.join("jsons", "response_sample.json") # 西国分寺→渋谷の乗換有のレスポンス
    @route_result = SearchNavitimeRoutesService.sample_fetch(file_name)
    
    # 経路検索結果に引き渡すBookmarkモデルのインスタンス変数
    if user_signed_in?
      
      @bookmark = Bookmark.new(departure: departure, destination: destination, time: time, status_check: true)
      @parameters = {
        bookmark: {
          name: "#{@bookmark.departure}→#{@bookmark.destination}",
          departure: @bookmark.departure,
          destination: @bookmark.destination,
          time: @bookmark.time,
          status_check: false,
        }
      }

    end
    
  end

  def sandbox

  end

  private

end
