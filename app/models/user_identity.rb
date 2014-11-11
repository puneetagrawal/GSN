require 'digest'

class UserIdentity 

  include Neo4j::ActiveNode
  include CustomNeo4j
  
  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :uuuid 
  property :uid
  property :email
  property :nickname
  property :provider
  property :country
  property :password
  property :password_digest
  property :remember_token
  property :oauth_token
  property :oauth_expires_at, type: DateTime
  # property :role, type: Boolean, default: false

  property :confirmation_token
  property :confirmed_at, type: DateTime
  property :confirmation_sent_at, type: DateTime
  property :color, default: "#00FF00"

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
  before_create :set_nickname
  before_create :create_confirmation_token, if: :is_normal_provider?
  # before_create :set_user
  after_create  :send_email_confirmation, if: :is_normal_provider?

  # has_one(:user).from(:identities)
 
  
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

  end


  def email_uniqueness
    if email.present?
      identity = UserIdentity.find(email: email.try(:downcase))    
      if identity.present? and (identity.email_changed? or new_record?)        
         errors.add(:email, "already exist.")
      end
    end
  end


  def secure_password
    if password_changed? or new_record?
      self.password = UserIdentity.encrypt_password(email, password) 
    end
  end

  # def create_remember_token
  #   # Create the remember token.
  #    self.remember_token = User.hash(User.new_random_token)
  # end

 

  def confirmed?    
     (!Rails.env.test? and is_normal_provider?) ? (confirmed_at.present?) : true
  end

  # def user_id
  # 	@user_id = user_id
  # end  

  def set_nickname    
  	self.nickname = "#{first_name} #{last_name}" if self.nickname.blank?    
  end  

  def create_confirmation_token
    # Create the confirmation token.
     self.confirmation_token = UserIdentity.hash(UserIdentity.new_random_token)
     self.confirmation_sent_at = Time.now.utc
  end

  def send_email_confirmation
    Notification.send_confirmation_email(self).deliver
  end

  def is_normal_provider?
    provider == "normal"
  end

  def identity_provider(provider, uid="", oauth_token="", oauth_expires_at="")
    relation = get_relation(provider)
    if relation.blank?
      create_provider_identity(provider, uid, oauth_token, oauth_expires_at)

      if provider=='normal'
        create_confirmation_token
        self.save
        # send_email_confirmation
      end
    else      
      update_provider_identity(relation)
      :error_messsage if provider=='normal'
    end    
  end

  def get_relation(provider)
    provider_relations = self.rels(type: :provider)

    relation = nil
    provider_relations.map do |pr|      
      if(pr.get_property("name") == provider)
        relation = pr
      end
    end 
    return relation 
  end

  def create_provider_identity(provider, uid, oauth_token, oauth_expires_at)
    provider_node = Provider.find(provider_name: provider)
    if provider_node.blank?
      provider_node = Provider.create(provider_name: provider) 
    end
    self.create_rel(:has_provider,  provider_node, {uid: uid, name: provider, created_at: Time.now.to_i, updated_at: Time.now.to_i, oauth_token: oauth_token.to_s, oauth_expires_at: oauth_expires_at.to_s})
  end

  def update_provider_identity(relation)
    relation.update_props(updated_at: Time.now.to_s)
  end

  def providers
    rels(type: :provider)
  end
  
  def groups
    rels(dir: :outgoing, type: :groups)
  end 

  def user
    rels(type: "User#identities")[0].start_node
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
