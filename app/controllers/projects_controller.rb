class ProjectsController < ApplicationController
  before_filter :current_user_has_membership, only: [:update, :destroy]
  
  respond_to :js
  
  def index
    @projects = Project.all
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def card
    @project = Project.find(params[:id])
    
    render 'card', layout: nil
  end
  
  def new
    @project = Project.new
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def create
    @project = Project.new(project_params)
    
    if @project.save
      @project.members << current_user unless @project.members.include? current_user
      return_or_redirect_to projects_url, notice: 'Project created.'
    else
      render 'new'
    end
  end
  
  def update
    @project = Project.find(params[:id])
    
    if @project.update_attributes(project_params)
      return_or_redirect_to projects_url, notice: 'Project updated.'
    else
      render 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    
    if @project.destroy
      respond_to do |format|
        format.html { return_or_redirect_to projects_url, notice: 'Project deleted.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { return_or_redirect_to projects_url, flash: { error: @project.errors.full_messages.first } }
        format.js
      end
    end
  end
private
  def project_params
    attributes = [:name, :code, member_ids: []]

    params.require(:project).permit *attributes
  end
end
