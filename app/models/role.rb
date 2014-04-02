class Role 
    include Neo4j::ActiveNode
    property :id
    property :name
end