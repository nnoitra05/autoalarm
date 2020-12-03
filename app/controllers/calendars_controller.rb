class CalendarsController < ApplicationController

  def show
  
  end

  def edit
  
  end

  def create
    
    calendar = Calendar.where(date: params[:date], user_id: current_user.id)

    if calendar.empty?
      calendar = Calendar.new(date: params[:date], user_id: current_user.id)
      calendar.save
    end

    binding.pry

    BookmarkCalendar.create(bookmark_id: params[:id], calendar_id: calendar.id)
    redirect_to bookmark_path(current_user.id)

  end
  
end
