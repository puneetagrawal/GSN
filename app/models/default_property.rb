class DefaultProperty
  # extend ActiveSupport::Concern
  include Neo4j::ActiveNode
  include CustomNeo4j 

  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :uuid 
  
end