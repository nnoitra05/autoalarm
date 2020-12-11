class BookmarksController < ApplicationController

  before_action :authenticate_user!

  def show

    # ログインユーザーと一致しているかを判断
    redirect_to root_path unless user_signed_in? && current_user.id == params[:id].to_i

    user = User.find(current_user.id)
    @nickname = user.nickname
    @bookmarks = user.bookmarks.where(status_check: true)


    @bookmark_calendar = BookmarkCalendar.new(bookmark_id: params[:id])
  end

  def edit

    binding.pry

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
      redirect_to bookmark_path
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

    if @bookmark.save
      redirect_to bookmark_path(current_user.id)
    else
      @bookmark.valid?
      file_name = Rails.public_path.join("jsons", "response_sample.json") # 西国分寺→渋谷の乗換有のレスポンス
      @route_result = SearchNavitimeRoutesService.sample_fetch(file_name)
      @datetime = params[:bookmark][:datetime]
      @parameters = {
        bookmark: bookmark_params,
        datetime: @datetime
      }
      @parameters[:bookmark][:status_check] = false
      @failure_comment = "ブックマークの名前を入力してください。"
      render search_trains_path
   
    end

  end

  def destroy

    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    redirect_to bookmark_path(current_user.id)

  end

  def register

    @failure_comment = ""
    @bookmark_calendar = BookmarkCalendar.new(bookmark_id: params[:id])

  end

  def register_without

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
    
    redirect_to user_path(current_user.id)

  end

  private

  def bookmark_params

    params.require(:bookmark).permit(:departure, :destination, :time, :departure_flag, :status_check, :name).merge(user_id: current_user.id)
    
  end

end
