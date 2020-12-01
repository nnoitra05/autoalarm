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
    if params[:day].to_i < 10
      params[:day] = "0#{params[:day]}"
    end
    if params[:time].to_i < 10
      params[:time] = "0#{params[:time]}"
    end
    arrival_at = "#{params[:year]}-#{params[:month]}-#{params[:day]}T#{params[:time]}:00"

    # サービスクラスSearchNavitimeRoutesServiceから条件を満たす最適なルートを取得
    @route_result = SearchNavitimeRoutesService.fetch(departure, destination, arrival_at)
    
  end

  def sandbox

  end
  
end
