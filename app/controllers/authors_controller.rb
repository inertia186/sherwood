class AuthorsController < ApplicationController
  respond_to :js, :json
  
  def index
    @minutes = (params[:minutes].presence || 1440).to_i
    @max_featured = (params[:max_featured].presence || 0).to_i
    @project = Project.find params[:project_id]
    @excluded_authors = @project.posts.
      created(@project.feature_duration_in_days.days.ago).
      published.rejected(false).
      distinct(:steem_author).select(:steem_author).pluck(:steem_author)
    @authors = @project.posts.published.rejected(false).
      distinct(:steem_author).select(:steem_author).pluck(:steem_author) -
      @excluded_authors
    @latest_authors = @authors.select do |author|
      author_latest_post(@authors, author) > @minutes.minutes.ago
    end.sort_by do |author|
      author_latest_post(@authors, author)
    end.reverse
    @oldest_authors = @authors.select do |author|
      author_latest_post(@authors, author) < @minutes.minutes.ago
    end.sort_by do |author|
      author_latest_post(@authors, author)
    end.reverse
  end
  
  def index_card
    index
    
    render 'index_card', layout: 'card'
  end
end
