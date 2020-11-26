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

    # まだ経路検索実装できてないので、検索するとこういうレスポンスが返ってくるという想定で@responseにハッシュを記述しておきます。
    # 時刻は全てDateTime.nowで仮置きしてます。
    # これを加工してtrains/searchビューに反映させるイメージで！
    @response = {
      departure: "西国分寺",
      destination: "渋谷",
      time: DateTime.now,
      routes: [
        {departure: "西国分寺", destination: "新宿", departure_time: DateTime.now, arrival_time: DateTime.now}, 
        {departure: "新宿", destination: "渋谷", departure_time: DateTime.now, arrival_time: DateTime.now}
      ]  
    }
    @routes = @response[:routes]
    
  end

  def sandbox

  end
  
end
