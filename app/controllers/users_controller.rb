class UsersController < ApplicationController

  before_action :authenticate_user!

  def show

    # 当日を過ぎ、かつstatus_check=falseのBookmarkレコードを削除する
    bookmarks = Bookmark.where(user_id: current_user.id, status_check: false)
    bookmarks.each do |bookmark|
      # status_check=falseのBookmarkCalendarレコードは1つのみなのでwhereではなくfind_by
      schedule = BookmarkCalendar.find_by(bookmark_id: bookmark.id)
      # 現在日付より前のBookmarkレコードを削除する
      bookmark.destroy if schedule.calendar.date < DateTime.now.to_date
    end

    # BookmarkCakendarレコードの登録がないCalendarレコードを削除
    calendars = Calendar.where(user_id: current_user.id)
    calendars.each do |calendar|
      calendar.destroy if BookmarkCalendar.where(calendar_id: calendar.id).empty?
    end

  end

  def edit

  end

  def update

    @user = User.find(params[:id])
    result = if current_user.id == @user
               # 自身の更新ならパスワード入力を求める
               @user.update_with_password(user_params)
             else
               @user.update(user_params)
             end
    if result
      # パスワード変更でログアウトするのを防ぐ
      sign_in(@user, bypass: true) if current_user.id == @user.id
      redirect_to user_path(@user)
    else
      render action: :edit
    end

  end

  def destroy

    user = User.find(params[:id])
    user.destroy
    redirect_to root_path

  end

  private

  def user_params

    params.require(:user).permit(:nickname, :email, :password)
    
  end

end
