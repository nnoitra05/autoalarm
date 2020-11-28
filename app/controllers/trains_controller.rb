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
    arrival_at = "#{params[:year]}-#{params[:month]}-#{params[:day]}T#{params[:time]}:00"

    # サービスクラスSearchNavitimeRoutesServiceから条件を満たす最適なルートを取得
    @route_result = SearchNavitimeRoutesService.fetch(departure, destination, arrival_at)
    
  end

  def sandbox

  end
  
end
