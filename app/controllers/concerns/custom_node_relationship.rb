module CustomNodeRelationship

	 extend ActiveSupport::Concern

	 def create_node(options = {})	 
        node     = options[:node]
        relation = options[:relation]
        label    = options[:label]=="Neo4j::identity" ? "Identity" : options[:label]
        color    = options[:color]

	 	{
       	           id:         node.neo_id.to_s,  
       	           label:      "#{label} #{node.neo_id}", 
       	           x:          Random.rand(1-6664664646),
       	           y:          Random.rand(1-6664664646),
       	           size:       Random.rand(1-6664664646),
       	           color:      color,
       	           properties: {
       	           	node:         node.props,
       	           	edge:         {}
       	                       },
       	           relation:   relation
        }

	 end

	 def create_edge(options = {})
         source   = options[:source]
         target   = options[:target]
         relation = options[:relation]
         color    = options[:color]
       
	 	{
				    id: "e #{relation.neo_id}",
				    source: source.neo_id.to_s,
				    target: target.neo_id.to_s,
				    size:   Random.rand(1-6664664646),
				    color:  color,
            type: "arrow"
        }
	 end



end