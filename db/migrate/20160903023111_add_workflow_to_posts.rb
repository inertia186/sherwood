class AddWorkflowToPosts < ActiveRecord::Migration[5.0]
  def up
    # Renaming 'proposed' to 'submitted'
    Post.where(status: 'proposed').update_all('status = "submitted"')
    
    # Invert the logic from flagged to published but keep the default.
    # A post will default as unpublished and marked as published
    # manually.
    rename_column :posts, :flagged, :published
    
    Post.update_all('published = ~published')
  end

  def down
    rename_column :posts, :published, :flagged
    Post.update_all('flagged = ~flagged')
  end
end
