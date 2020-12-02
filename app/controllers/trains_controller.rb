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
    arrival_at = params[:arrival_at]
    departure_flag = params[:departure_flag].to_i

    # サービスクラスSearchNavitimeRoutesServiceから条件を満たす最適なルートを取得
    # @route_result = SearchNavitimeRoutesService.fetch(departure, destination, arrival_at, departure_flag)

    # NAVITIME APIのコール回数削減のために経路検索結果をdumpしたので、特に不要な場合はこちらのメソッドで読込してください。
    # 直通か非直通かでそれぞれjsonファイルが違うので、目的に合わせてコメントアウトを外してください。
    file_name = Rails.public_path.join("jsons", "response_sample_no_transit.json") # 所沢→渋谷の直通経路のレスポンス
    # file_name = Rails.public_path.join("jsons", "response_sample_no_transit.json") # 西国分寺→渋谷の乗換有のレスポンス
    @route_result = SearchNavitimeRoutesService.sample_fetch(file_name)
    
    
  end

  def sandbox

  end
  
  def create
  
  end

  private
  def bookmark_params
  
  end

end
