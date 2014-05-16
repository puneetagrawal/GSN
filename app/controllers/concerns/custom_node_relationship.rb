module CustomNodeRelationship

	 extend ActiveSupport::Concern

	 def create_node(options = {})	 
        node     = options[:node]
        relation = options[:relation]
        label    = options[:label]
        color    = options[:color]
        relation_name = []
        relation_id = []
        node.rels.each do |rel|
          relation_name << rel.load_resource['type']
          relation_id <<  "Relation #{rel.neo_id}"
        end
        label_html = "#{label} #{node.neo_id}"
	 	    {
       	           id:         node.neo_id.to_s,  
       	           label:      label_html, 
       	           x:          Random.rand(1-6664664646),
       	           y:          Random.rand(1-6664664646),
       	           size:       Random.rand(1-6664664646),
       	           color:      color,
                   type:       "image",
                   url:     "/assets/img/img4.png",
       	           properties: {
       	           	node:         node.props,
       	           	edge:         {
                        relation_name: relation_name,
                        relation_id: relation_id
                    }
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
				    id: " #{relation.neo_id}",
				    source: source.neo_id.to_s,
				    target: target.neo_id.to_s,
				    size:   1000,
				    color:  color,
            type: "arrow"
        }
	 end



end