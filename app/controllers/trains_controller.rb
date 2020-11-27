class TrainsController < ApplicationController

  def index

    train_information = FetchTrainsApisService.fetch(FetchTrainsApisService.apis[:ti])
    @information_list = []

    train_information.each do |train_info|

      train_status_str = "odpt:trainInformationStatus"
      train_infomation_text_str = "odpt:trainInformationText"

      if train_info.keys.include?(train_status_str) && !train_info[train_status_str].nil?
        @information_list << train_info[train_infomation_text_str]["ja"]
      end

    end

    @information_list = @information_list.uniq

  end

  def search

    departure = params[:departure]
    destination = params[:destination]

    arrival_at = "#{params[:year]}-#{params[:month]}-#{params[:day]}T#{params[:time]}:00"
    @route_result = SearchNavitimeRoutesService.fetch(departure, destination, arrival_at)["items"][0]
    
  end

  def sandbox

  end
  
end
