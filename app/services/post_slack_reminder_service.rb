

class PostSlackReminderService

  # user-level
  def self.set_user_client
    Slack.configure do |config|
      config.token = ENV["USER_SLACK_TOKEN"]
    end
    return Slack::Web::Client.new
  end

  # bot-level
  def self.set_client
    Slack.configure do |config|
      config.token = ENV["SLACK_TOKEN"]
    end
    return Slack::Web::Client.new
  end
  
  # user.slack_idに対しunixtimeにリマインドを設定
  def self.post_reminder(user, time)

    begin
      
      client = PostSlackReminderService.set_user_client

      client.reminders_add(
        time: time.to_s,
        user: user.slack_id,
        text: "Setting AutoAlarm"
      )
    
    rescue => post_exception

      binding.pry
      return post_exception
      
    end
    
  end

  # AutoAlarmワークスペースに参加しているユーザー全てのリマインドリストを取得
  def self.fetch_reminders

    client = PostSlackReminderService.set_user_client

    return client.reminders_list

  end

  # AutoAlarmワークスペースに参加しているユーザーリストを取得
  def self.fetch_users

    client = PostSlackReminderService.set_client

    return client.users_list

  end

  # trains/searchページからunixtimeを取得してその条件でreminders_listを起動し、idに変換したのちreminders_delete
  def self.delete_reminder(user, time)

    reminder_id = ""
    reminders = PostSlackReminderService.fetch_reminders[:reminders]
    
    begin

      reminders.each do |reminder|
        if reminder[:time].to_i == time.to_i && reminder[:user] == user.slack_id
          client = PostSlackReminderService.set_user_client
          client.reminders_delete(reminder: reminder[:id])
          break
        end
      end

    rescue => delete_exception

      binding.pry
      return delete_exception

    end

  end

end