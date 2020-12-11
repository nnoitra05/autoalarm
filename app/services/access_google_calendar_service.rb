

class AccessGoogleCalendarService

  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  APPLICATION_NAME = "Google Calendar API Ruby Quickstart".freeze
  CREDENTIALS_JSON = JSON.parse(ENV["CREDENTIALS_JSON"])
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN = YAML.load_file(Rails.root.join("..", "token.yaml"))
  TOKEN["default"] = JSON.parse(TOKEN["default"])
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

  def initialize(user)

    # Initialize the API
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize

    # Fetch the next 10 events for the user
    @calendar_id = "primary"
  
  end
  
  
  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize

    client_id = Google::Auth::ClientId.from_hash CREDENTIALS_JSON
    #token_store = Google::Auth::Stores::TokenStore.new token: TOKEN
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, TOKEN
    user_id = "default"

    binding.pry

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
  
    return credentials
  
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

    response = @service.list_events(calendar_id,
      max_results:   10,
      single_events: true,
      order_by:      "startTime",
      time_min:      DateTime.now.rfc3339
    )

    puts "Upcoming events:"
    puts "No upcoming events found" if response.items.empty?

    response.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} : #{event.location} (#{start})"
      puts "  - #{event.id}"
    end

  end


  def destroy

  end

end


class TempAccessGoogleCalendarService

  def initialize(user)

    # Userモデルにcredentials_jsonの中身を格納するカラムを作成してそこから引っ張ってくるように変更する必要あり
    @CREDENTIALS_JSON = JSON.parse(ENV["CREDENTIALS_JSON"])

    @calendar_id = "primary"
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = "Google Calendar API Ruby Quickstart"

    @service.authorization = authorize

  end


  def authorize

    # 認証用の情報を格納する

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: @CREDENTIALS_JSON,
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR
    )
    # アクセストークンを持ってくる（失敗したらエラー？）
    authorizer.fetch_access_token!
    # authorizerをリターン
    return authorizer

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
