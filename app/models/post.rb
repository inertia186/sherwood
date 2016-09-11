include ActionView::Helpers::DateHelper

class Post < ActiveRecord::Base
  ALLOWED_STATUS = %w(proposed submitted accepted rejected passed)
  HUMANIZED_ATTRIBUTES = {
    slug: 'Permalink'
  }

  belongs_to :project
  belongs_to :editing_user, class_name: 'User', foreign_key: :editing_user_id
  
  validates :status, inclusion: { in: ALLOWED_STATUS }
  validates_uniqueness_of :slug, scope: :project
  validates_format_of :slug, with: /@[a-z0-9\-\.]+\/.*/
  validate :author_cooldown
  validate :on_blockchain, if: :slug_changed?

  scope :status, lambda { |status_name, status = true|
    where(status: status_name).tap do |r|
      return status ? r : where.not(id: r.select(:id))
    end
  }

  scope :proposed, lambda { |proposed = true| status 'proposed', proposed }
  scope :submitted, lambda { |submitted = true| status 'submitted', submitted }
  scope :accepted, lambda { |accepted = true| status 'accepted', accepted }
  scope :rejected, lambda { |rejected = true| status 'rejected', rejected }
  scope :passed, lambda { |passed = true| status 'passed', passed }
  
  scope :published, lambda { |published = true|
    # Have to use a verbose logic because SQLite is stupid.
    if published
      where("posts.published = ?", true)
    else
      where("posts.published = ?", false)
    end
  }
  
  scope :in_cooldown, lambda { |author, cooldown|
    published.where(steem_author: author).created(cooldown)
  }
  
  scope :created, lambda { |date, created = true|
    where('posts.created_at > ?', date).tap do |r|
      return created ? r : where.not(id: r.select(:id))
    end
  }
  scope :today, lambda { created(Time.now.beginning_of_day) }
  
  scope :ordered, lambda { |options = {by: :created_at, direction: 'asc'}|
    options[:by] ||= :created_at
    options[:direction] ||= 'asc'
    order(options[:by] => options[:direction])
  }
  
  scope :query, lambda { |query|
    where("LOWER(posts.content_cache) LIKE ?", "%#{query.downcase}%")
  }
  
  scope :steem_mode, lambda { |mode, invert = false|
    where('posts.content_cache LIKE ?', "%\"mode\":\"#{mode}\"%").tap do |r|
      return invert ? r : where.not(id: r.select(:id))
    end
  }
  
  scope :steem_first_payout, lambda { |first_payout = true|
    steem_mode('first_payout', first_payout)
  } 
  
  scope :steem_second_payout, lambda { |second_payout = true|
    steem_mode('second_payout', second_payout)
  } 
  
  scope :steem_archived, lambda { |archived = true|
    steem_mode('archived', archived)
  } 
  
  def self.human_attribute_name ( attr, options = {} )
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  after_validation do
    ContentGetterJob.perform_later(id) unless Rails.env.test?
  end
  
  def self.order_by_active_votes(options = {direction: 'asc'})
    posts = all.sort_by do |post|
      post.content.active_votes.size
    end
    
    if options[:direction] == 'desc'
      posts = posts.reverse
    end
    
    posts
  end

  def self.order_by_pending_payout_value(options = {direction: 'asc'})
    posts = all.sort_by do |post|
      post.content.pending_payout_value.split(' ').first
    end
    
    if options[:direction] == 'desc'
      posts = posts.reverse
    end
    
    posts
  end
  
  def self.deactivate_all!
    update_all("status = 'passed'")
  end
  
  def to_param
    "#{id}-#{slug.to_s.parameterize}"
  end
  
  def proposed?
    status == 'proposed'
  end
  
  def submitted?
    status == 'submitted'
  end
  
  def accepted?
    status == 'Post.accepted'
  end
  
  def rejected?
    status == 'Post.rejected'
  end
  
  def passed?
    status == 'Post.passed'
  end
  
  def steem_first_payout?
    Post.steem_first_payout.include? self
  end
  
  def steem_second_payout?
    Post.steem_second_payout.include? self
  end
  
  def steem_archived?
    Post.steem_archived.include? self
  end
  
  def author_cooldown
    if errors.empty?
      author = slug.split('/').first.split('@').last
      cooldown_days = project.feature_duration_in_days
      cooldown = cooldown_days.days.ago
      posts = project.posts.where.not(id: self).in_cooldown(author, cooldown)
      
      if !!author && published? && posts.any?
        post = posts.ordered.last
        words = time_ago_in_words(post.created_at)
        error_message = <<-DONE
          This project has a #{cooldown_days} day feature limit and @#{author}
          has already been featured #{words} ago.
        DONE
        errors.add(:base, error_message)
      end
    end
  end
  
  def on_blockchain
    if errors.empty?
      errors.add(:slug, 'This post not found in blockchain.') unless content?
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
  
  def best_payout_value
    @best_payout_value if !!@best_payout_value
    
    total = content.total_payout_value.split(' ').first.to_f
    curator = content.curator_payout_value.split(' ').first.to_f
    pending = content.pending_payout_value.split(' ').first.to_f
    total_pending = content.total_pending_payout_value.split(' ').first.to_f
    
    @best_payout_value = [past = total + curator, total_pending].max
  end

  def best_payout_value_formatted
    "$%.2f" % best_payout_value
  end
  
  def plagiarism_checked?
    !!plagiarism_checked_at
  end
  
  def cache_key
    [to_param, updated_at, project.updated_at, editing_user.updated_at]
  end
end
