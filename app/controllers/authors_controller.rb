class AuthorsController < ApplicationController
  respond_to :js, :json
  
  def index
    @project = Project.find params[:project_id]
    @excluded_authors = @project.posts.created(@project.feature_duration_in_days.days.ago).
      published.rejected(false).
      pluck(:steem_author)
    @authors = @project.posts.published.rejected(false).
      pluck(:steem_author) - @excluded_authors
    @latest_authors = @authors.select do |author|
      author_latest_post(@authors, author) > 24.hours.ago
    end.sort_by do |author|
      author_latest_post_timestamp(@authors, author).to_i
    end
    @oldest_authors = @authors.select do |author|
      author_latest_post(@authors, author) < 24.hours.ago
    end.sort_by do |author|
      author_latest_post_timestamp(@authors, author)
    end
  end
  
  def index_card
    index
    
    render 'index_card', latout: nil
  end
end
