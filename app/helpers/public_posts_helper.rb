module PublicPostsHelper
  def public_posts_table_row_class(post)
    if post.published? && post.rejected?
      'table-danger'
    else
      nil
    end
  end
  
  def public_post_detailed_payout(post)
    payouts = []
    c = post.content
    
    (v = c.total_payout_value) != '0.000 SBD' and payouts << "Author: #{v}"
    (v = c.curator_payout_value) != '0.000 SBD' and payouts << "Curator: #{v}"
    (v = c.pending_payout_value) != '0.000 SBD' and payouts << "Pending: #{v}"
    (v = c.total_pending_payout_value) != '0.000 SBD' and payouts << "Total Pending: #{v}"
      
    payouts.join("; ").gsub(' SBD', '') + ' (SBD)'
  end
end
