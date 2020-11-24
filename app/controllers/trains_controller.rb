class TrainsController < ApplicationController

  def index

    @train_information = FetchTrainsApisService.fetch(FetchTrainsApisService.apis[:ti])
    @information_list = []

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

  end
end
