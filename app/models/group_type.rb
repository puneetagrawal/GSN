class GroupType 
    include Neo4j::ActiveNode

     property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime  

  has_one(:creator).from(:users)
  has_n(:node_types).to(NodeType)

end