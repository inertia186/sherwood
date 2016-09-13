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

  def authors(author_names)
    @steem_authors ||= steem_api.get_accounts(author_names).result
  end
  
  def find_author(author_names, author_name)
    authors(author_names).select { |a| a.name == author_name }.last
  end
  
  def author_latest_post_class(author_names, author_name)
    a = find_author(author_names, author_name)
    date = Time.parse(a.last_root_post + " UTC")
    
    if 24.hours.ago > date
      'btn btn-xs btn-secondary'
    else
      'btn btn-xs btn-success'
    end
  end
  
  def author_latest_post(author_names, author_name)
    a = find_author(author_names, author_name)
    "(#{time_ago_in_words(Time.parse(a.last_root_post + " UTC"))} ago)"
  end
  
  def copyscape_credit_balance
    return '' if Plagiarism.test_mode
    
    @copyscape_credit_balance ||= "#{pluralize((Plagiarism.credits), 'credits')} remain"
  rescue
    ''
  end
end
