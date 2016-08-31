class PublicPostsController < ApplicationController
  skip_before_action :authorize_user!
  respond_to :js, :json
  
  def index
    @project = Project.find params[:project_id]
    @posts = @project.posts.ordered
  end
end