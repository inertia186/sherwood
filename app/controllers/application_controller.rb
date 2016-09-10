class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authorize_user!

  helper_method :steem_api
  helper_method :markdown
  helper_method :current_user, :current_project, :current_user_has_membership?
private
  def steem_api
    @steem_api ||= Radiator::Api.new
  end
  
  def markdown(string)
    RDiscount.new(string).to_html.html_safe
  end
  
  def authorize_user!
    unless current_user
      flash[:warning] = "Please sign in."
      redirect_to new_session_path(return_to: request.url)
    end
  end
  
  def current_user_has_membership
    project = current_project
    
    unless project.members.include? current_user
      flash[:warning] = "Sorry, membership in #{project.name} is required."
      redirect_to dashboard_path(return_to: request.url)
    end
  end

  def current_user_has_membership?(project)
    project.members.include? current_user
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
    @project ||= if !!params[:post] && !!params[:post][:project_id]
      Project.find params[:post][:project_id]
    elsif !!params[:project_id]
      Project.find params[:project_id]
    elsif !!params[:id]
      Project.find params[:id]
    else
      Project.find_by_code('rhw')
    end
  end
end
