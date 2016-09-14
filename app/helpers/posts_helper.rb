module PostsHelper
  def post_card_class(post)
    if post.rejected?
      'card-outline-danger'
    elsif post.steem_first_payout?
      'card-outline-primary'
    elsif post.steem_second_payout?
      'card-outline-secondary'
    elsif post.steem_archived?
      'card-outline-secondary'
    end
  end
end
