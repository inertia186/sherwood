class AddNotesToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :notes, :text
    add_column :posts, :flagged, :boolean, null: false, default: '0'
  end
end
