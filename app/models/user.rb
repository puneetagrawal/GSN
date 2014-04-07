require 'digest'
class User
  include Neo4j::ActiveNode

  
  property :id
  property :first_name
  property :last_name
  property :country
  # property :remember_token
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :uuid, default: SecureRandom.uuid


  validates :uuid, presence: true
  validate :id, presence: true
  validate :first_name, presence: true
  validate :last_name, presence: true
  validate :country, presence: true

  # property :confirmation_token
  # property :confirmed_at, type: DateTime
  # property :confirmation_sent_at, type: DateTime
  
  has_n(:identities).to(Neo4j::Identity)

  # before_create :create_confirmation_token, if: :is_normal_provider?
  # before_create :set_user
  # after_create  :send_email_confirmation, if: :is_normal_provider?

  # attr_accessor :provider

  # class << self
  # 	def new_random_token
  #     SecureRandom.urlsafe_base64
  #   end

  #   def hash(token)
  #     Digest::SHA1.hexdigest(token.to_s)
  #   end

  # end

  # def confirmed?
  # 	get_identity("normal").confirmed_at.present?
  # end

  def full_name
    "#{first_name} #{last_name}"
  end
 
  #  def create_confirmation_token
  #   # Create the confirmation token.
  #    self.confirmation_token = Neo4j::Identity.hash(Neo4j::Identity.new_random_token)
  #    self.confirmation_sent_at = Time.now.utc
  #  end

  # def send_email_confirmation
  #   Notification.send_confirmation_email(self).deliver
  # end

  # def is_normal_provider?
  # 	provider == "normal"
  # end

  # def email
  #   normal_identity.email
  # end

  def get_identity(provider)
  	identities.find(provider: provider).next
  end


end