

class AccessGoogleCalendarService

  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  APPLICATION_NAME = "Google Calendar API Ruby Quickstart".freeze
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  def initialize(user)

    @CREDENTIALS_JSON = JSON.parse(ENV["CREDENTIALS_JSON"])

    # authorize
    client_id = Google::Auth::ClientId.from_hash @CREDENTIALS_JSON

    binding.pry

    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
          "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials

    # Initialize the API
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    # Fetch the next 10 events for the user
    calendar_id = "primary"

    response = service.list_events(calendar_id,
                                  max_results:   10,
                                  single_events: true,
                                  order_by:      "startTime",
                                  time_min:      DateTime.now.rfc3339)
    puts "Upcoming events:"
    puts "No upcoming events found" if response.items.empty?
    response.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} : #{event.location} (#{start})"
      puts "  - #{event.id}"
    end

  end

  def create(summary, start_time)

    event = {
      summary: "[autoalarm]#{summary}",
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time),
      # Rational(1, 24 * 60) => 1分, イベントの終了時刻は開始1分後
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time + Rational(1, 24 * 60)),
      # リマインダー設定
      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,
        overrides: [Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'popup',minutes: 1)]
      )
    }

  end

  def destroy

  end

end
