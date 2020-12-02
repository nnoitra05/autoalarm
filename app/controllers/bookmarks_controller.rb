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
    Bookmark.create(bookmark_params)
  end

  private
  def bookmark_params
    params.require(:bookmark).permit(:name).merge(user_id: current_user.id)
  end
end
