class UsersController < ApplicationController

  def show

    calendars = Calendar.where(user_id: current_user.id)

    @bookmark_calendars = []

    calendars.each do |calendar|
      BookmarkCalendar.where(calendar_id: calendar.id).each do |bookmark_calendar|
        @bookmark_calendars << bookmark_calendar
      end
    end

    # 2次元配列部や空配列部を強制的に1次元化
    @bookmark_calendars.flatten!

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
