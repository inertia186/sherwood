class SessionsController < ApplicationController
  skip_before_action :authorize_user!, except: :destroy
  
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      return_or_redirect_to dashboard_url, notice: "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to dashboard_url, notice: "Logged out!"
  end
end
