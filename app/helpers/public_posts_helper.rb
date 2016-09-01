module PublicPostsHelper
  def public_posts_table_row_class(post)
    if post.flagged?
      'table-danger'
    else
      nil
    end
  end
  
  def public_post_detailed_payout(post)
    [
      "Total: #{post.content.total_payout_value}",
      "Curator: #{post.content.curator_payout_value}",
      "Pending: #{post.content.pending_payout_value}",
      "Total Pending: #{post.content.total_pending_payout_value}"
    ].join("; ").gsub(' SBD', '') + ' (SBD)'
  end
end
