class UsersController < ApplicationController
  skip_before_action :authorize_user!, except: %(edit update destroy)
  
  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      return_or_redirect_to root_url, notice: "Signed up!"
    else
      render "new"
    end
  end
  
  def update
    @user = current_user
    
    p = if user_params[:password].blank?
      user_params.delete(:password).delete(:password_confirmation)
      user_params
    else
      user_params
    end
    
    if @user.update_attributes(p)
      return_or_redirect_to root_url, notice: 'Updated.'
    else
      render 'edit'
    end
  end
private
  def user_params
    attributes = [:email, :nick, :password, :password_confirmation]

    params.require(:user).permit *attributes
  end
end
