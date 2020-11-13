class TrainsController < ApplicationController

  def index

    @train_information = FetchTrainsApisService.fetch(FetchTrainsApisService.apis[:ti])
    @information_list = []

  end

  def search
  end
end
