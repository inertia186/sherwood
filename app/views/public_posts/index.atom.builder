atom_feed do |feed|
  feed.body @project.name
  feed.updated @posts.maximum(:created_at)
  
  @posts.each do |post|
    feed.entry post, url: post.canonical_url do |entry|
      entry.title post.content.title
      entry.content post.content.body
      entry.author do |author|
        author.name "@#{post.steem_author}"
      end
    end
  end
end
