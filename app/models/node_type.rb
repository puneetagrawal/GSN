class NodeType 
  include Neo4j::ActiveNode
  include CustomNeo4j

  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :field_name
  property :color, default: "#00FFFF"

  has_one(:creator).from(:users)
  has_n(:properties).to(NodeAttribute)
  before_save { self.field_name = field_name.downcase }  
 
  
end