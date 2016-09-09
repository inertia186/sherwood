class PublicPostsController < ApplicationController
  skip_before_action :authorize_user!
  respond_to :js, :json
  
  def index
    sort_field = params[:sort_field]
    sort_order = params[:sort_order]
    @project = Project.find params[:project_id]
    cooldown_days = @project.feature_duration_in_days
    cooldown = cooldown_days.days.ago
    @posts = @project.posts.published.where('posts.created_at > ?', cooldown)
    
    @posts = if sort_field == 'active_votes'
      @posts.order_by_active_votes(direction: sort_order)
    elsif sort_field == 'pending_payout_value'
      @posts.order_by_pending_payout_value(direction: sort_order)
    else
      @posts.ordered(by: sort_field, direction: sort_order)
    end
  end
end