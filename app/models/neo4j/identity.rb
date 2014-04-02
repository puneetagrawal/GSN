require 'digest'
module Neo4j
class Identity 

  include Neo4j::ActiveNode
  
  property :id
  property :uid
  property :email
  property :nickname
  property :provider
  property :password
  property :password_digest
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :remember_token
  property :oauth_token
  property :oauth_expires_at, type: DateTime
  # property :role, type: Boolean, default: false

  property :confirmation_token
  property :confirmed_at, type: DateTime
  property :confirmation_sent_at, type: DateTime

  before_validation :set_nickname

  # validates :nickname, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validate :email_uniqueness
  validates :password, length: { minimum: 6 },
                               if: :is_normal_provider?
  validates_confirmation_of :password,
                          if: lambda { |m| m.password.present? }
  index :email
  index :remember_token
  index :nickname

  before_save { self.email = email.downcase }
  before_save :secure_password

  # before_create :create_remember_token
  before_create :create_confirmation_token, if: :is_normal_provider?
  # before_create :set_user
  after_create  :send_email_confirmation, if: :is_normal_provider?

  has_one(:user).from(:identities)
  has_one(:role).from(:role)
  
  attr_accessor :first_name, :last_name

  class << self

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def encrypt_password(email, password)
      secure_hash("#{secure_hash("#{email}-#{password}")}-#{password}")
    end

    def new_random_token
      SecureRandom.urlsafe_base64
    end

    def hash(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    def first
     all.map{|u| u}[0]
    end

    def last
       all.map{|u| u}[Neo4j::Identity.count - 1]
    end
    
  end


  def email_uniqueness
    identity = Neo4j::Identity.find(email: email)    
    if identity.present? and (identity.email_changed? or new_record?)
      errors.add(:email, "already exist.")
    end    
  end


  def secure_password
    if password_changed? or new_record?
      self.password = Neo4j::Identity.encrypt_password(email, password) 
    end
  end

  # def create_remember_token
  #   # Create the remember token.
  #    self.remember_token = User.hash(User.new_random_token)
  # end

 

  def confirmed?
     (is_normal_provider?) ? (confirmed_at.present?) : true
  end

  # def user_id
  # 	@user_id = user_id
  # end  

  def set_nickname
  	nickname = "#{first_name} #{last_name}" if self.nickname.blank?    
  end  

  def create_confirmation_token
    # Create the confirmation token.
     self.confirmation_token = Neo4j::Identity.hash(Neo4j::Identity.new_random_token)
     self.confirmation_sent_at = Time.now.utc
  end

  def send_email_confirmation
    Notification.send_confirmation_email(self).deliver
  end

  def is_normal_provider?
    provider == "normal"
  end



  # def set_user
  #   puts "OOOOOOOOOOOOOOOOOOOOOOOOO"
  #   puts user_id    
  # 	user = if user_id.present? 
  # 	         User.find(params[:id]) 
  # 	       else
  # 	         User.create(first_name: first_name, last_name: last_name, country: country)  	  		
  # 	       end
  # 	self.user = user
  # end


end
end