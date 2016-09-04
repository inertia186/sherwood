module ApplicationHelper
  def project_stats(project)
    'TODO'
  end
  
  def sortable_header_link_to(name, field)
    options = params.merge(action: controller.action_name, sort_field: field, page: nil, query: params[:query], sort_order: params[:sort_order] == 'asc' ? 'desc' : 'asc')
    options.permit!
    link_to name, url_for(options)
  end
end
