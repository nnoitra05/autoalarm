

class PostSlackReminderService

  def self.set_client

    Slack.configure do |config|
      config.token = ENV["SLACK_OAUTH_TOKEN"]
    end

    return Slack::Web::Client.new

  end
  
  def self.post_reminder

    begin
      
      client = PostSlackReminderService.set_client
  
      client.reminders_add(
        time: "in 1 minutes",
        user: "D01GZ2A1D9A",
        text: "Setting AutoAlarm"
      )

      return PostSlackReminderService.fetch_reminders
    
    rescue => post_exception

      return post_exception
      
    end
    
  end

  def self.delete_reminder

    client = PostSlackReminderService.set_client

    client.reminders_delete(
      reminder: "reminder ID"
    )

  end

  def self.fetch_reminders

    client = PostSlackReminderService.set_client

    return client.reminder_list

  end

end