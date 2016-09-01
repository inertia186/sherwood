class CreateMemberships < ActiveRecord::Migration[5.0]
  def up
    create_table :memberships do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false
      t.timestamps null: false
    end
    
    add_index :memberships, [:project_id, :user_id], name: :index_memberships_on_project_id_and_user_id, unique: true
    
    if !!(rhw = Project.find_by_code('rhw'))
      User.all.find_each do |user|
        Membership.create(project: rhw, user: user)
      end
    end
    
    remove_index :posts, name: :index_posts_on_slug
    add_index :posts, :slug, name: :index_posts_on_slug
  end
  
  def down
    drop_table :memberships
    remove_index :posts, name: :index_posts_on_slug
    add_index :posts, :slug, name: :index_posts_on_slug, unique: true
  end
end
