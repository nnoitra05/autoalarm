

class GetNavitimeParamsService

  @API_KEY = "06ac31ab38msha5fdb3338e65166p1e090djsn9608e40d68db"
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