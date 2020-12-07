

class SearchNavitimeRoutesService

  URL = "https://navitime-route-totalnavi.p.rapidapi.com/route_transit"

  def self.fetch(departure, destination, datetime, departure_flag)
    
    conn = Faraday.new(URL)

    response = conn.get do |request|
      
      request.params["rapidapi-host"] = GetNavitimeParamsService.route_host
      request.params["rapidapi-key"] = GetNavitimeParamsService.key
      # ConvertWordToNodeServiceを使って文字情報をノードIDに変換する
      departure_dump = ConvertWordToNodeService.fetch(departure)
      request.params[:start] = departure_dump["items"][0]["id"]
      destination_dump = ConvertWordToNodeService.fetch(destination)
      request.params[:goal] = destination_dump["items"][0]["id"]
      # departure_flagがtrueなら到着時刻に間に合うような結果を、falseなら指定時刻以降に出発する結果を返すように設定する
      if departure_flag
        request.params[:goal_time] = datetime
      else
        request.params[:start_time] = datetime
      end

    end

    res = JSON.parse(response.body)["items"][0]

    route_result = {}
    route_result[:departure] = res["summary"]["start"]["name"]
    route_result[:destination] = res["summary"]["goal"]["name"]
    route_result[:transit_count] = res["summary"]["move"]["transit_count"]
    route_result[:sections] = []

    # res["sections"]は配列要素
    # [出発駅情報, 駅間の乗換情報, 1回目の乗換駅情報, 駅間の乗換情報,..., n回目の乗換駅情報, 駅間の乗換情報, 目的地情報]が格納されている
    res["sections"].each_with_index do |route, idx|

      # 駅間の乗換情報のみを格納する
      if idx.odd?

        route_info = {}

        route_info[:departure] = route["transport"]["links"][0]["from"]["name"]
        route_info[:departure_time] = route["from_time"].to_datetime.strftime("%H時%M分")
        route_info[:destination] = route["transport"]["links"][0]["to"]["name"]
        route_info[:destination_time] = route["to_time"].to_datetime.strftime("%H時%M分")
        route_info[:line_name] = route["line_name"]
        route_info[:dt_destination_time]= route["to_time"]
        route_info[:index]= idx

        
        route_result[:sections] << route_info

      end
            

    end
    return route_result

  end


  def self.sample_fetch(file_name)

    response_sample = JsonDumpService.read(file_name)

    res = response_sample["items"][0]

    route_result = {}
    route_result[:departure] = res["summary"]["start"]["name"]
    route_result[:destination] = res["summary"]["goal"]["name"]
    route_result[:transit_count] = res["summary"]["move"]["transit_count"]
    route_result[:sections] = []

    # res["sections"]は配列要素
    # [出発駅情報, 駅間の乗換情報, 1回目の乗換駅情報, 駅間の乗換情報,..., n回目の乗換駅情報, 駅間の乗換情報, 目的地情報]が格納されている
    res["sections"].each_with_index do |route, idx|

      # 駅間の乗換情報のみを格納する
      if idx.odd?

        route_info = {}

        route_info[:departure] = route["transport"]["links"][0]["from"]["name"]
        route_info[:departure_time] = route["from_time"].to_datetime.strftime("%H時%M分")
        route_info[:destination] = route["transport"]["links"][0]["to"]["name"]
        route_info[:destination_time] = route["to_time"].to_datetime.strftime("%H時%M分")
        route_info[:line_name] = route["line_name"]
        route_info[:dt_destination_time]= route["to_time"]
        
        route_result[:sections] << route_info
       
      end
    
    end

    return route_result

  end

end


