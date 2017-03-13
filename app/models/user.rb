class User < ActiveRecord::Base
	has_many :teamusers, dependent: :destroy
	has_many :eventusers, dependent: :destroy
	has_many :event, :through => :eventusers
	has_many :team, :through  => :teamusers
	
	has_secure_password
	attr_accessor :remember_token,:event_accept
	GENDER_TYPES = ["Male", "Female"]
	CATEGORY_TYPES = ["Admin", "User"]
	
	before_save { self.email = email.downcase }
	
	validates :name,  presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
	                format: { with: VALID_EMAIL_REGEX },
	                uniqueness: { case_sensitive: false }
	
	has_secure_password
	# validates :password, presence: true, length: { minimum: 6 }

	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
		                                              BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token.
	def User.new_token
	  SecureRandom.urlsafe_base64
	end

	  

  	# Remembers a user in the database for use in persistent sessions.
  def remember
  	return false if remember_digest.nil?
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

	def self.search(search)
	  if search
	    where('lower(name) LIKE ? or lower(empid) LIKE ?', "%#{search}%","%#{search}%")
	  else
	    all
	  end
	end

end
