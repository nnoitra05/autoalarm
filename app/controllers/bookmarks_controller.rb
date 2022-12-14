class BookmarksController < ApplicationController

  before_action :authenticate_user!

  def show

    # user = User.find(current_user.id)
    # @nickname = user.nickname
    # @bookmarks = user.bookmarks.where(status_check: true)
    
  end

  def index

    user = User.find(current_user.id)
    @nickname = user.nickname
    @bookmarks = user.bookmarks.where(status_check: true)
    
  end

  def edit

    # ログインユーザーと一致しているかを判断
    redirect_to root_path unless user_signed_in? && current_user.id == Bookmark.find(params[:id]).user_id

    user = User.find(current_user.id)
    @bookmark = Bookmark.find(params[:id])
    @nickname = user.nickname
    @failure_comment = ""
    
  end

  def update

    @failure_comment = ""
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.update(bookmark_params)
      redirect_to bookmarks_path
    else
      @nickname = current_user.nickname
      @bookmark.valid?
      error_messages = @bookmark.errors.messages.values.flatten.uniq
      @failure_comment = "空欄部分があります。入力してください。" if error_messages.include?("can't be blank")
      render :edit
    end

  end
  
  def create
  
    @bookmark = Bookmark.new(bookmark_params)

    begin

      # ブックマークの保存ができた場合
      if @bookmark.save
        redirect_to bookmarks_path
      # ブックマークの保存ができない（ブックマーク名を空欄にしている）場合
      else

        @bookmark.name = "#{@bookmark.departure}→#{@bookmark.destination}"
        @bookmark.save
        redirect_to bookmarks_path

      end

    rescue => create_exception

    end

  end

  def destroy

    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    redirect_to bookmarks_path

  end

  def register

    @failure_comment = ""
    @bookmark_calendar = BookmarkCalendar.new(bookmark_id: params[:id])

  end

  def register_without

    begin

      # status_check = falseの状態でブックマーク保存
      bookmark = Bookmark.find_by(bookmark_params)
      if bookmark.nil?
        Bookmark.create(bookmark_params)
        bookmark = Bookmark.find_by(bookmark_params)
      end

      calendar = Calendar.find_by(date: params[:datetime].to_date, user_id: current_user.id)
      if calendar.nil?
        Calendar.create(date: params[:datetime].to_date, user_id: current_user.id)
        calendar = Calendar.find_by(date: params[:datetime].to_date, user_id: current_user.id)
      end

      bookmark_calendar = BookmarkCalendar.find_by(bookmark_id: bookmark.id, calendar_id: calendar.id)
      if bookmark_calendar.nil?
        BookmarkCalendar.create(bookmark_id: bookmark.id, calendar_id: calendar.id)
      end

      redirect_to users_path

    rescue => register_without_ecxeption

    end

  end

  private

  def bookmark_params

    params.require(:bookmark).permit(:departure, :destination, :time, :departure_flag, :status_check, :name).merge(user_id: current_user.id)
    
  end

end
