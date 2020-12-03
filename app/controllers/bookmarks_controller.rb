class BookmarksController < ApplicationController

  def show

    user = User.find(current_user.id)
    @nickname = user.nickname
    @bookmarks = user.bookmarks
    
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
