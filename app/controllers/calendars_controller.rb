class CalendarsController < ApplicationController

  before_action :authenticate_user!

  def show
  
  end

  def edit
  
  end

  def create

    calendar = Calendar.find_by(date: params[:date], user_id: current_user.id)

    if calendar.nil?
      calendar = Calendar.new(date: params[:date], user_id: current_user.id)
      calendar.save
    end

    bookmark_calendar = BookmarkCalendar.find_by(bookmark_id: params[:bookmark_id], calendar_id: calendar.id)

    if bookmark_calendar.nil?
      bookmark_calendar = BookmarkCalendar.new(bookmark_id: params[:bookmark_id], calendar_id: calendar.id)
      if bookmark_calendar.save
        redirect_to bookmark_path(current_user.id)
      else
        @bookmark_calendar = BookmarkCalendar.new
        @bookmark_calendar.bookmark = Bookmark.find(params[:id])
        render register_bookmark_path(params[:id])
      end
    end

  end

  def destroy

  end

  private
  
end
