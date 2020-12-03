class BookmarksController < ApplicationController

  def show

    user = User.find(params[:id])
    @nickname = user.nickname
    @bookmarks = user.bookmarks
    
  end

  def edit
  
    user = User.find(params[:id])
    @nickname = user.nickname
    @bookmarks = user.bookmarks
    
  end
  
  def create
  
    bookmark = Bookmark.create(bookmark_params)
    # Bookmarkが保存できなかった場合の分岐を作る必要あり
    bookmark.save
    redirect_to root_path
    
  end

  private

  def bookmark_params

    params.require(:bookmark).permit(:departure, :destination, :time, :status_check, :name).merge(user_id: current_user.id)
    
  end

end
