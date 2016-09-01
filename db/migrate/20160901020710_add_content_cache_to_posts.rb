class AddContentCacheToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :content_cache, :text
    add_column :posts, :content_cached_at, :timestamp
  end
end
