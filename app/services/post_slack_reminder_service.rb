

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
  
  def self.post_reminder

    begin
      
      client = PostSlackReminderService.set_user_client

      client.reminders_add(
        time: "in 1 minutes",
        user: "U01GL5DRE3Y",
        text: "Setting AutoAlarm"
      )

      return PostSlackReminderService.fetch_reminders
    
    rescue => post_exception

      return post_exception
      
    end
    
  end

  def self.delete_reminder

    client = PostSlackReminderService.set_user_client

    client.reminders_delete(
      reminder: "reminder ID"
    )

  end

  def self.fetch_reminders

    client = PostSlackReminderService.set_user_client

    return client.reminders_list

  end

  def self.fetch_users

    client = PostSlackReminderService.set_client

    return client.users_list

  end

end