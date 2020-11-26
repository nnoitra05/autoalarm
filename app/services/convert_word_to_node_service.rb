

class ConvertWordToNodeService

  URL = "https://navitime-transport.p.rapidapi.com/transport_node"

  def self.fetch(word)
    
    conn = Faraday.new(URL)
    
    response = conn.get do |request|
      
      request.params["rapidapi-host"] = GetNavitimeParamsService.transport_host
      request.params["rapidapi-key"] = GetNavitimeParamsService.key
      request.params[:word] = word

      # レスポンスとして取得する情報を駅に限定
      request.params[:type] = "station"

    end
    
    return JSON.parse(response.body)
    
  end

end


