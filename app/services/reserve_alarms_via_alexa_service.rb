

class ReserveAlarmsViaAlexaService

  def self.fetch(alexa_params)
  
    response = AlexaRubykit::Response.new
    response.add_speech('Ruby is running ready!')
    response.build_response
      
  end

end