class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
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
end
