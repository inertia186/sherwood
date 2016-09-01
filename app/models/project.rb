class Project < ActiveRecord::Base
  has_many :posts, dependent: :restrict_with_error
  has_many :editing_users, through: :posts
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  
  validates_presence_of :code
  validates_uniqueness_of :code
  
  def to_param
    "#{id}-#{code.to_s.parameterize}"
  end
  
  def cache_key
    [to_param, updated_at, posts.maximum(:updated_at), editing_users.maximum(:updated_at)]
  end
end