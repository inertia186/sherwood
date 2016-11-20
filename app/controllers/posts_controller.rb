class PostsController < ApplicationController
  before_action :current_user_has_membership, only: [:create, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :check_for_plagiarism
  respond_to :js, :json
  before_action :init_params, only: :index
  
  def index
    @posts = if !!@project
      @project.posts.this_week
    else
      Post.all.this_week
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
    @post = Post.new(status: 'submitted', editing_user: current_user, project_id: params[:project_id])
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
  
  def check_for_plagiarism
    @post = Post.find(params[:id])
    
    if !!@post.plagiarism_results_url
      Rails.logger.info "Skipped Plagiarism check, reusing last result."
      respond_to do |format|
        format.html {
          redirect_to search.results_url
        }
        format.json
      end
      
      return
    end
    
    search = Plagiarism.text_search(@post.content.body)
    Rails.logger.info "Plagiarism results; count: #{search.count}, words: #{search.words}, url: #{search.results_url}"
    @post.update_attributes(plagiarism_results_url: search.results_url, plagiarism_checked_at: Time.now)
    
    if search.success? && search.results?
      respond_to do |format|
        format.html {
          redirect_to search.results_url
        }
        format.json
      end
    else
      if !!(@error = search.response.response['response']['error'])
        respond_to do |format|
          format.html {
            return_or_redirect_to project_post_url(@post.project, @post), flash: { error: "Error: #{@error}" }
          }
          format.json
        end
      else
        respond_to do |format|
          format.html {
            return_or_redirect_to project_post_url(@post.project, @post), notice: "No plagiarism found."
          }
          format.json
        end
      end
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
  
  def init_params
    @project_id = session[:posts_project_id]
    @sort_field = session[:posts_sort_field]
    @sort_order = session[:posts_sort_order]
    @query = session[:posts_query]
    @status = session[:posts_status]
    @published = session[:posts_published]
    @limit = session[:posts_limit]
    
    @project = Project.find params[:project_id] if params[:project_id]
    
    if !!params[:sort_field] || !!params[:sort_order] || !!params[:query] ||
      !!params[:status] || !!params[:published] || !!params[:limit]
      @sort_field = params[:sort_field]
      @sort_order = params[:sort_order]
      @query = params[:query]
      @status = params[:status]
      @published = params[:published]
      @limit = params[:limit]
    end
    
    session[:posts_project_id] = @project_id
    session[:posts_sort_field] = @sort_field
    session[:posts_sort_order] = @sort_order
    session[:posts_query] = @query
    session[:posts_status] = @status
    session[:posts_published] = @published
    session[:posts_limit] = @limit
  end
end
