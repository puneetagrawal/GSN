class GroupType 
  
  include Neo4j::ActiveNode
  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime  

  has_one(:creator).from(:users)
  has_n(:node_types).to(NodeType)
  
  

  def has_name_desc?
    field_names = node_types.map(&:field_name).map(&:downcase)
    check_field_names = ["name", "description"]
    rem_field_names = field_names & check_field_names   
    rem_field_names.size == 2 ? true : false    
  end
  

end