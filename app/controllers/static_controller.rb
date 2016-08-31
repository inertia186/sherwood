class StaticController < ApplicationController
  skip_before_action :authorize_user!, only: %w(default_project)
  
  def default_project
    redirect_to public_posts_url(project_id: Project.first)
  end
end
