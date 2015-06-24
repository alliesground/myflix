class User < ActiveRecord::Base
  include Tokenable

  before_save { self.email = email.downcase }
  has_many :reviews
  has_many :queue_items, -> { order("position") }
  has_many :relationships, foreign_key: "follower_id"
  has_many :followed_users, through: :relationships, source: :followed_user
  has_many :inverse_relationships, class_name: 'Relationship', foreign_key: "followed_id"
  has_many :followers, through: :inverse_relationships, source: :follower
  has_many :invitations
  
  VALID_EMAIL_REGEX = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  validates_presence_of :full_name
  validates :email, presence: true, 
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX}, 
                    uniqueness: { case_sensitive: false }

  has_secure_password validations: false

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def reviews_count
    "Review".pluralize(reviews.count) + "\s(#{reviews.count})"
  end

  def following?(other_user)
    followed_users.include?(other_user)
  end

  def follow(other_user)
    relationships.create(followed_id: other_user.id)
  end
end
