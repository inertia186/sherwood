class AddSteemDetailsToPosts < ActiveRecord::Migration[5.0]
  def change
    # These are fields that will never change.
    add_column :posts, :steem_id, :string
    add_column :posts, :steem_author, :string
    add_column :posts, :steem_permlink, :string
    add_column :posts, :steem_category, :string
    add_column :posts, :steem_parent_permlink, :string
    add_column :posts, :steem_created, :string
    add_column :posts, :steem_url, :string
  end
end
