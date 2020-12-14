class UsersController < ApplicationController

  before_action :authenticate_user!

  def index

    date = DateTime.now.to_date

    # 当日を過ぎたCalendarレコード及びそれに紐付くBookmark(status_check: false)レコードを削除する
    calendars = current_user.calendars.where("date < ?", date)
    
    calendars.each do |calendar|

      schedules = calendar.bookmark_calendars
      
      schedules.each do |schedule|
        bookmark = schedule.bookmark
        bookmark.destroy if bookmark.status_check == false
        schedule.destroy
      end
      
      calendar.destroy
    
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
