module AuthorsHelper
  def hours(minutes)
    divisor = if minutes % 60 == 0
      60
    else
      60.0
    end
    
    pluralize minutes / divisor, 'hour'
  end
  
  def author_latest_post_class(project, minutes, author_names, author_name)
    a = find_author(author_names, author_name)
    date = Time.parse(a.last_root_post + " UTC")
    
    value = if minutes.minutes.ago > date
      'btn btn-xs btn-secondary'
    else
      'btn btn-xs btn-success'
    end
    
    if author_above_max_featured(project, author_name)
      value << ' disabled'
    end
    
    value
  end

  def author_featured_count(project, author)
    @author_featured_counts ||= {}
    @author_featured_counts[{project => author}] ||= @project.posts.where(steem_author: author).
      published.rejected(false).count
  end
  
  def author_featured_count_tip(project, author)
    "Featured " + pluralize(author_featured_count(project, author), 'time')
  end
  
  def author_above_max_featured(project, author)
    return false if @max_featured == 0
    return true if author_featured_count(project, author) > @max_featured
    
    false
  end
end
