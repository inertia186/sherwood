class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authorize_user!

  helper_method :current_user, :current_project
private
  def authorize_user!
    unless current_user
      flash[:warning] = "Please sign in."
      redirect_to new_session_path(return_to: request.url)
    end
  end
  
  def return_or_redirect_to(*opts)
    return_to = params[:return_to]

    if return_to.present?
      redirect_to return_to
    else
      redirect_to(*opts)
    end
  end

  def current_user
    if session[:user_id]
      user = User.where(id: session[:user_id]).first
      @current_user ||= user
    end
  end
  
  def current_project
    @project ||= Project.find_by_code('rhw')
  end
end
