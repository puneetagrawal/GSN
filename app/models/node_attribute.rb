class NodeAttribute #< DefaultProperty
  
  include Neo4j::ActiveNode
  include CustomNeo4j 

  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :uuid 

  property :name
  property :attr_type
  property :color, default: "#FFFF00"

  validates :name, presence: true
  validate :name_uniqueness

  has_one(:creator).from(:users)
  before_save { self.name = name.downcase }

  def name_uniqueness   
    if name.present?      
      n_attribute = NodeAttribute.find(name: name.try(:downcase), attr_type: attr_type ) 
      if n_attribute.present? and (n_attribute.name_changed? or new_record?)        
         errors.add(:name, "already exist.")
      end
    end
  end

end