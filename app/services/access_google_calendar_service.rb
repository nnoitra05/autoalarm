

class AccessGoogleCalendarService

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
      json_key_io: @CREDENTIALS_JSON
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR)
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
