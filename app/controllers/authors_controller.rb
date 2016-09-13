class AuthorsController < ApplicationController
  respond_to :js, :json
  
  def index
    @project = Project.find params[:project_id]
    @authors = @project.posts.created(@project.feature_duration_in_days.days.ago, false).
      published.rejected(false).
      pluck(:steem_author)
    @latest_authors = @authors.select do |author|
      author_latest_post(@authors, author) > 24.hours.ago
    end.sort_by do |author|
      author_latest_post_timestamp(@authors, author)
    end
    @oldest_authors = @authors.select do |author|
      author_latest_post(@authors, author) < 24.hours.ago
    end.sort_by do |author|
      author_latest_post_timestamp(@authors, author)
    end
  end
end
