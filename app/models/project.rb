class Project < ActiveRecord::Base
  has_many :posts, dependent: :restrict_with_error
  has_many :editing_users, through: :posts
  
  def to_param
    "#{id}-#{code.parameterize}"
  end
  
  def cache_key
    [to_param, updated_at, posts.maximum(:updated_at), editing_users.maximum(:updated_at)]
  end
end