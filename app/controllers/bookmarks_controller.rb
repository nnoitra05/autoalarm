class BookmarksController < ApplicationController

  def show

    user = User.find(current_user.id)
    @nickname = user.nickname
    binding.pry
    @bookmarks = user.bookmarks.where(status_check: true)
    
  end

  def edit
  
    user = User.find(current_user.id)
    @bookmark = Bookmark.find(params[:id])
    @nickname = user.nickname
    
  end

  def update

    bookmark = Bookmark.find(params[:id])
    if bookmark.update(bookmark_params)
      redirect_to bookmark_path
    else
      render :edit
    end

  end
  
  def create
  
    binding.pry
    bookmark = Bookmark.new(bookmark_params)
    # Bookmarkが保存できなかった場合の分岐を作る必要あり
    if bookmark.save
      redirect_to bookmark_path(current_user.id)
    else
      render :create
    end

  end

  def destroy

    bookmark = Bookmark.find(params[:id])
    if bookmark.destroy
      redirect_to bookmark_path(current_user.id)
    end

  end

  def register

    @bookmark_calendar = BookmarkCalendar.new
    @bookmark_calendar.bookmark = Bookmark.find(params[:id])

  end

  # うまく動かないので修正
  def register_without

    # status_check = falseの状態でブックマーク保存
    bookmark = Bookmark.find_by(bookmark_params)
    if bookmark.nil?
      Bookmark.create(bookmark_params)
      bookmark = Bookmark.find_by(bookmark_params)
    end

    calendar = Calendar.find_by(date: bookmark_params[:time].to_date, user_id: current_user.id)
    if calendar.nil?
      Calendar.create(date: bookmark_params[:time].to_date, user_id: current_user.id)
      calendar = Calendar.find_by(date: bookmark_params[:time].to_date, user_id: current_user.id)
    end

    bookmark_calendar = BookmarkCalendar.find_by(bookmark_id: bookmark.id, calendar_id: calendar.id)
    if bookmark_calendar.nil?
      bookmark_calendar = BookmarkCalendar.create(bookmark_id: bookmark.id, calendar_id: calendar.id)
    end
    
    redirect_to user_path(current_user.id)

  end

  private

  def bookmark_params

    params.require(:bookmark).permit(:departure, :destination, :time, :status_check, :name).merge(user_id: current_user.id)
    
  end

end
