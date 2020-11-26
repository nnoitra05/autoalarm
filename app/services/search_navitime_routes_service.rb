

class SearchNavitimeRoutesService

  URL = "https://navitime-route-totalnavi.p.rapidapi.com/route_transit"

  def self.fetch(departure, destination, arrival_at, departure_flag = true)
    
    conn = Faraday.new(URL)

    response = conn.get do |request|
      
      request.params["rapidapi-host"] = GetNavitimeParamsService.route_host
      request.params["rapidapi-key"] = GetNavitimeParamsService.key
      # ConvertWordToNodeServiceを使って文字情報をノードIDに変換する
      departure_dump = ConvertWordToNodeService.fetch(departure)
      request.params[:start] = departure_dump["items"][0]["id"]
      destination_dump = ConvertWordToNodeService.fetch(destination)
      request.params[:goal] = destination_dump["items"][0]["id"]
      # 現状は:arrival_atを:start_timeに代入する（出発時刻準拠で検索する）
      request.params[:start_time] = arrival_at

      # オプション

    end
    
    return JSON.parse(response.body)
    
  end

end


