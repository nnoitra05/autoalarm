class UsersController < ApplicationController

  before_action :authenticate_user!

  def index

    date = DateTime.now.to_date

    # 当日を過ぎたBookmarkレコードを削除する
    current_user.bookmarks.each do |bookmark|
      # status_check=falseのBookmarkCalendarレコードは1つのみなのでwhereではなくfind_by
      schedule = BookmarkCalendar.find_by(bookmark_id: bookmark.id)
      # 現在日付より前のBookmarkレコードを削除する
      bookmark.destroy if (!schedule.nil? && schedule.calendar.date < date)
    end

    # 当日を過ぎたCalendarレコードを削除する
    current_user.calendars.each do |calendar|
      calendar.destroy if calendar.date < date
    end

  end

  def show

  end

  def edit

    # ログインユーザーと一致しているかを判断
    redirect_to root_path unless user_signed_in? && current_user.id == params[:id].to_i

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
      redirect_to users_path
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
