class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, on: :create, unless: :password_hash_changed?
  validates :password, length: {minimum: 8}, if: :password_changed?
  validates_presence_of :nick
  validates_presence_of :email
  validates_uniqueness_of :email
  
  with_options dependent: :restrict_with_error do |assoc|
    assoc.has_many :edited_posts, class_name: 'Post', foreign_key: :editing_user_id
  end
  
  has_many :memberships
  has_many :projects, through: :memberships

  def self.authenticate(email, password)
    user = find_by_email(email)
    if !!user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
private
  def password_changed?
    password.present? && password_confirmation.present?
  end
end
