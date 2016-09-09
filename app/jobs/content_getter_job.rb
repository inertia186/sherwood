class ContentGetterJob < ApplicationJob
  queue_as :default

  def perform(post_id = nil)
    if !!post_id
      !!Post.find(post_id).content
    else
      !!Post.steem_archived(false).sample.content!
    end
  end
end
