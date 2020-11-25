

class SearchNavitimeRoutesService

  URL = "https://navitime-route-totalnavi.p.rapidapi.com/route_transit"
  API_HOST = "navitime-route-totalnavi.p.rapidapi.com"
  API_KEY = "06ac31ab38msha5fdb3338e65166p1e090djsn9608e40d68db"

  def self.fetch(departure, destination, arrival_at, departure_flag = true)
    
    conn = Faraday.new(URL)

    response = conn.get do |request|
      
      request.params["rapidapi-host"] = API_HOST
      request.params["rapidapi-key"] = API_KEY
      # ConvertWordToNodeServiceを使って文字情報をノードIDに変換する
      request.params[:start] = ConvertWordToNodeService(departure)
      request.params[:goal] = ConvertWordToNodeService(destination)
      # 現状は:arrival_atを:start_timeに代入する（出発時刻準拠で検索する）
      request.params[:start_time] = arrival_at

      # オプション

    end
    
    return JSON.parse(response.body)
    
  end

end


