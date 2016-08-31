class InitialMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :nick, null: false
      t.string :password_hash
      t.string :password_salt
      t.timestamps null: false
    end
    
    add_index :users, :email, name: :index_users_on_email, unique: true
    
    create_table :projects do |t|
      t.string :code, null: false
      t.string :name
      t.timestamps null: false
    end
    
    add_index :projects, :code, name: :index_projects_on_code, unique: true
    
    create_table :posts do |t|
      t.string :status, null: false, default: 'proposed'
      t.string :slug, null: false
      t.integer :project_id, null: false
      t.integer :editing_user_id, null: false
      t.timestamps null: false
    end
    
    add_index :posts, :slug, name: :index_posts_on_slug, unique: true
  end
end
