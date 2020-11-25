

class ConvertWordToNodeService

  URL = "https://navitime-route-totalnavi.p.rapidapi.com/transport_node"
  API_HOST = "navitime-route-totalnavi.p.rapidapi.com"
  API_KEY = "06ac31ab38msha5fdb3338e65166p1e090djsn9608e40d68db"

  def self.fetch(word)
    
    conn = Faraday.new(URL)
    
    response = conn.get do |request|
      
      request.params["rapidapi-host"] = API_HOST
      request.params["rapidapi-key"] = API_KEY
      request.params[:word] = word

      # レスポンスとして取得する情報を駅に限定
      request.params[:type] = "station"

    end
    
    return JSON.parse(response.body)
    
  end

end


