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
     @route_result = SearchNavitimeRoutesService.fetch(departure, destination, arrival_at, departure_flag)

    # NAVITIME APIのコール回数削減のために経路検索結果をdumpしたので、特に不要な場合はこちらのメソッドで読込してください。
    # @route_result = SearchNavitimeRoutesService.sample_fetch
    
  end

  def sandbox

  end
  
  def create
  
  end

  private
  def bookmark_params
  
  end

end
