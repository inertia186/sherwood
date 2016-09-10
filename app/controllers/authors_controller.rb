class AuthorsController < ApplicationController
  respond_to :js, :json
  
  def index
    @project = Project.find params[:project_id]
    @authors = @project.posts.created(@project.feature_duration_in_days, false).
      published.rejected(false).
      pluck(:steem_author)
  end
end
