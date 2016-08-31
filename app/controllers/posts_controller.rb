class PostsController < ApplicationController
  respond_to :js, :json
  
  def index
    @posts = Post.all
    @project = Project.find params[:project_id] if params[:project_id]
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
      return_or_redirect_to project_post_url(@post.project_id, @post), notice: 'Post created.'
    else
      render 'new'
    end
  end
  
  def update
    @post = Post.find(params[:id])
    
    if @post.update_attributes(post_params)
      return_or_redirect_to project_post_url(@post.project_id, @post), notice: 'Post updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    
    if @post.destroy
      respond_to do |format|
        format.html { return_or_redirect_to project_posts_url(@post.project_id), notice: 'Post deleted.' }
        format.js
      end
    end
  end
private
  def post_params
    attributes = [:status, :slug, :project_id]
    
    params.require(:post).permit *attributes
  end
end
