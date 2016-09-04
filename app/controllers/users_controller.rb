class UsersController < ApplicationController
  skip_before_action :authorize_user!
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      return_or_redirect_to dashboard_url, notice: "Signed up!"
    else
      render "new"
    end
  end
private
  def user_params
    attributes = [:email, :nick, :password, :password_confirmation]

    params.require(:user).permit *attributes
  end
end
