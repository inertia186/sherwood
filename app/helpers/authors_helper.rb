module AuthorsHelper
  def hours(minutes)
    divisor = if minutes % 60 == 0
      60
    else
      60.0
    end
    
    pluralize minutes / divisor, 'hour'
  end
  
  def author_latest_post_class(minutes, author_names, author_name)
    a = find_author(author_names, author_name)
    date = Time.parse(a.last_root_post + " UTC")
    
    if minutes.minutes.ago > date
      'btn btn-xs btn-secondary'
    else
      'btn btn-xs btn-success'
    end
  end
end
