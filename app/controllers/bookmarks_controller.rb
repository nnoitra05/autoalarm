class BookmarksController < ApplicationController
  def show
  end

  def edit
  end

  def create
    Bookmark.create(bookmark_params)
  end

  private
  def bookmark_params
    params.require(:bookmark).permit(:name).merge(user_id: current_user.id)
  end
end
