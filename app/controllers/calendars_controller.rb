class CalendarsController < ApplicationController

  before_action :authenticate_user!

  def show
  
  end

  def edit
  
  end

  def create

    # ブックマークをカレンダーに登録できなかった際に表示する変数の初期化
    @failure_comment = ""

    # 日付が入力されなかった場合の処理
    if params[:date].empty?

      @failure_comment = "日付を入力してください。"
      @bookmark_calendar = BookmarkCalendar.new(bookmark_id: params[:bookmark_id])
      redirect_to bookmarks_path(current_user.id)

    # 日付が入力された場合の処理
    else

      # Calendarレコードの作成
      calendar = Calendar.find_by(date: params[:date], user_id: current_user.id)
      if calendar.nil?
        Calendar.create(date: params[:date], user_id: current_user.id)
        calendar = Calendar.find_by(date: params[:date], user_id: current_user.id)
      end
      # BookmarkCalendarレコードの作成
      @bookmark_calendar = BookmarkCalendar.find_by(bookmark_id: params[:bookmark_id], calendar_id: calendar.id)
      if @bookmark_calendar.nil?
        BookmarkCalendar.create(bookmark_id: params[:bookmark_id], calendar_id: calendar.id)
        redirect_to users_path
      # bookmark_calendarが既にカレンダーに登録されている場合の処理
      else
        @failure_comment = "既にカレンダーに登録されています。"
        redirect_to bookmarks_path(current_user.id)
      end

    end

  end

  def destroy

  end

  private
  
end
