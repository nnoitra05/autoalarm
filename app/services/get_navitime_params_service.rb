

class GetNavitimeParamsService

  @API_KEY = ENV["NAVITIME_API_KEY"]
  @ROUTE_API_HOST = "navitime-route-totalnavi.p.rapidapi.com"
  @TRANSPORT_API_HOST = "navitime-transport.p.rapidapi.com"
  
  def self.key
    return @API_KEY
  end

  def self.route_host
    return @ROUTE_API_HOST
  end

  def self.transport_host
    return @TRANSPORT_API_HOST
  end
end