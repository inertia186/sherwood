module PublicPostsHelper
  def public_posts_table_row_class(post)
    if post.flagged?
      'table-danger'
    else
      nil
    end
  end
end
