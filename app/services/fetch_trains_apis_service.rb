

class FetchTrainsApisService

  URL = "https://api-tokyochallenge.odpt.org/api/v4"
  CONSUMER_KEY = "pUDvG82NZDiE8ufhvvH2iR3DnMok1YRMO7h7jkOpinU"

  def self.fetch(api_path)
    
    conn = Faraday.new("#{URL}/#{api_path}")
    
    response = conn.get do |request|
      
      request.params["acl:consumerKey"] = CONSUMER_KEY

    end
    
    return JSON.parse(response.body)
    
  end

  def self.apis

    return train_apis = {ps: "odpt:PassengerSurvey", # 駅の乗降人員
                         r: "odpt:Railway", # 路線情報
                         rd: "odpt:RailDirection", # 方向
                         rf: "odpt:RailwayFare", # 運賃情報
                         s: "odpt:Station", # 駅情報
                         stt: "odpt:StationTimetable", # 駅単位の時刻表
                         t: "odpt:Train", # 電車の位置情報
                         ti: "odpt:TrainInformation", # 路線の運行情報
                         ttt: "odpt:TrainTimetable", # 電車単位の時刻表
                         tt: "odpt:TrainType" # 列車種別
                        }
  
  end

end


