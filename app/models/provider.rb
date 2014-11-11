class Provider 
  include Neo4j::ActiveNode

  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime 
  property :uuuid 
  property :color, default: "#A52A2A"
  property :provider_name

end
