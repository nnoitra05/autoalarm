

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
  
  # slack_idに対しunixtimeにリマインドを設定
  def self.post_reminder(slack_id, time)

    begin
      
      client = PostSlackReminderService.set_user_client
      reminders = PostSlackReminderService.fetch_reminders(slack_id)[:reminders]
      reminder_flag = false

      reminders.each do |reminder|
        if reminder[:time].to_i == time.to_i && reminder[:user] == slack_id
          reminder_flag = true
        end
      end

      unless reminder_flag
        client.reminders_add(
          time: time.to_s,
          user: slack_id,
          text: "Setting AutoAlarm"
        )
      end
    
    rescue => post_exception

      return post_exception
      
    end
    
  end

  # AutoAlarmワークスペースに参加しているユーザー全てのリマインドリストを取得
  def self.fetch_reminders(slack_id)

    client = PostSlackReminderService.set_user_client

    reminders_list = client.reminders_list
    
    reminders_list[:reminders].each_with_index do |reminder, idx|
      reminders_list[:reminders].delete(reminder) if reminder[:user] != slack_id
    end
    
    return reminders_list

  end

  # 既にリマインドがされているかをbooleanで判定
  def self.reminded?(slack_id, times_list)

    client = PostSlackReminderService.set_user_client

    reminders_list = PostSlackReminderService.fetch_reminders(slack_id)
    reminded_flag = false

    reminders_list[:reminders].each_with_index do |reminder, idx|
      reminded_flag = true if times_list.include?(reminder[:time])
    end

    return reminded_flag

  end

  # trains/searchページからunixtimeを取得してその条件でreminders_listを起動し、idに変換したのちreminders_delete
  def self.delete_reminder(slack_id, time)

    reminder_id = ""
    reminders = PostSlackReminderService.fetch_reminders(slack_id)[:reminders]
    
    begin

      reminders.each do |reminder|
        if reminder[:time].to_i == time.to_i && reminder[:user] == slack_id
          client = PostSlackReminderService.set_user_client
          client.reminders_delete(reminder: reminder[:id])
          break
        end
      end

    rescue => delete_exception

      return delete_exception

    end

  end

end