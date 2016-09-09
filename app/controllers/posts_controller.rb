class PostsController < ApplicationController
  before_action :current_user_has_membership, only: [:create, :update, :destroy]
  respond_to :js, :json
  
  def index
    @project = Project.find params[:project_id] if params[:project_id]
    @sort_field = params[:sort_field]
    @sort_order = params[:sort_order]
    @query = params[:query]
    @status = params[:status]
    @published = params[:published]
    @limit = params[:limit]
    
    @posts = if !!@project
      @project.posts
    else
      Post.all
    end
    
    @posts = @posts.query(@query) if @query.present?
    @posts = @posts.where(status: @status) if @status.present?
    @posts = @posts.published(@published == 'true') if @published.present?
    @posts = @posts.limit(@limit) if @limit.present?
    
    if @sort_field.present?
      @posts = @posts.ordered(by: @sort_field, direction: @sort_order)
    end
  end
  
  def show
    @post = Post.find params[:id]
  end
  
  def card
    @post = Post.find(params[:id])
    
    render 'card', layout: nil
  end
  
  def new
    @post = Post.new(editing_user: current_user, project_id: params[:project_id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params.merge(editing_user: current_user))
    
    if @post.save
      return_or_redirect_to project_post_url(@post.project, @post), notice: 'Post created.'
    else
      render 'new'
    end
  end
  
  def update
    @post = Post.find(params[:id])
    
    if @post.update_attributes(post_params)
      return_or_redirect_to project_post_url(@post.project, @post), notice: 'Post updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    
    if @post.destroy
      respond_to do |format|
        format.html { return_or_redirect_to project_posts_url(@post.project), notice: 'Post deleted.' }
        format.js
      end
    end
  end
private
  def post_params
    attributes = [:status, :slug, :project_id, :status, :notes, :published]
    
    params.require(:post).permit *attributes
  end
end
