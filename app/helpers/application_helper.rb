module ApplicationHelper
  def project_stats(project)
    if project.posts.any?
      "Latest post created #{time_ago_in_words project.posts.maximum(:created_at)} ago."
    else
      "No posts."
    end
  end
  
  def sortable_header_link_to(name, field)
    options = params.merge(action: controller.action_name, sort_field: field, page: nil, query: params[:query], sort_order: params[:sort_order] == 'asc' ? 'desc' : 'asc')
    options.permit!
    link_to name, url_for(options)
  end
end
