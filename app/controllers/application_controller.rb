class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authorize_user!
  before_action :process_posts

  helper_method :steem_api
  helper_method :markdown
  helper_method :current_user, :current_project, :current_user_has_membership?
  
  helper_method :authors, :find_author, :author_latest_post,
    :author_latest_post_timestamp
    
  # rescue_from RestClient::BadGateway, with: :steem_api_error
  # rescue_from RestClient::RequestTimeout, with: :steem_api_error
private
  def steem_api_error
    # TODO Implement something like this:
    # TODO https://mattbrictson.com/dynamic-rails-error-pages
    render file: 'public/steem_api_error.html', status: 500, layout: false,
      notice: "The steem node could not be reached.  Try again later."
  end

  def steem_api
    @steem_api ||= Radiator::Api.new(RADIATOR_OPTIONS)
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
  
  def process_posts
    PostProcessJob.perform_later if action_name == 'index'
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
  
  def authors(author_names)
    @steem_authors ||= steem_api.get_accounts(author_names).result
  end
  
  def find_author(author_names, author_name)
    authors(author_names).select { |a| a.name == author_name }.last
  end
  
  def author_latest_post(author_names, author_name)
    a = find_author(author_names, author_name)
    Time.parse(a.last_root_post + " UTC")
  end
  
  def author_latest_post_timestamp(author_names, author_name)
    "(#{time_ago_in_words(author_latest_post(author_names, author_name))} ago)"
  end
end
