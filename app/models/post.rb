class Post < ActiveRecord::Base
  belongs_to :project
  belongs_to :editing_user, class_name: 'User', foreign_key: :editing_user_id
  
  validates_uniqueness_of :slug, scope: :project
  validates_format_of :slug, with: /@[a-z0-9\-\.]+\/.*/
  validate :on_blockchain, if: :slug_changed?

  scope :status, lambda { |status_name, status = true|
    where(status: status_name).tap do |r|
      return status ? r : where.not(id: r.select(:id))
    end
  }

  scope :proposed, lambda { |proposed = true| status 'proposed', proposed }
  scope :active, lambda { |active = true| status 'active', active }
  scope :archived, lambda { |archived = true| status 'archived', archived }
  
  scope :ordered, lambda { |options = {by: :created_at, direction: 'asc'}|
    order(options[:by] => options[:direction])
  }
  
  after_validation do
    ContentGetterJob.perform_later(id)
  end
  
  def to_param
    "#{id}-#{slug.to_s.parameterize}"
  end
  
  def on_blockchain
    if errors.empty?
      errors.add(:slug, 'not found') unless content?
    end
  end
  
  def canonical_url
    "https://steemit.com#{steem_url}"
  end
  
  def content
    if content_cache.nil?
      api = Radiator::Api.new(RADIATOR_OPTIONS)
      author = slug.split('/').first.split('@').last
      permlink = slug.split('/')[1..-1].join
      content = api.get_content(author, permlink).result
      self.content_cache = content.to_json
      self.content_cached_at = Time.now
      self.steem_id ||= content.id
      self.steem_author ||= content.author
      self.steem_permlink ||= content.permlink
      self.steem_category ||= content.category
      self.steem_parent_permlink ||= content.parent_permlink
      self.steem_created ||= content.created
      self.steem_url ||= content.url
      save
    end
    
    Hashie::Mash.new(JSON[content_cache])
  end
  
  def content!
    self.content_cache = nil
    self.content_cached_at = nil
    self.steem_id = nil
    self.steem_author = nil
    self.steem_permlink = nil
    self.steem_category = nil
    self.steem_parent_permlink = nil
    self.steem_created = nil
    self.steem_url = nil
    content
  end
  
  def content?
    content.id != '0.0.0'
  end
  
  def title
    content.title.empty? ? slug : content.title
  end
  
  def cache_key
    [to_param, updated_at, project.updated_at, editing_user.updated_at, content]
  end
end
