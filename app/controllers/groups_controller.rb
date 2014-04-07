class GroupsController < ApplicationController

	def index
		# @groups = Group.all
		 identity = Neo4j::Identity.find(uuid: params[:identity])
         @groups = {}
         @groups[:nodes] = []
         @groups[:edges] = []		 
		 check_node = []

		 # random_num = Random.rand(1-6664664646)
		 rel_users = identity.rels()
		 rel_users.each do |r|
         
		   e_node = r.end_node
		   e_node_id = r.end_node.neo_id
		   s_node_id = r.start_node.neo_id
		   edge_properties = r.props
		   edge_relation = r.load_resource.present? ? r.load_resource["type"] : ""
		   color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'
		   # Rails.logger.debug edge		   
           unless check_node.include? e_node_id
           	 check_node << e_node_id
             @groups[:nodes] << {
           	          id: e_node_id.to_s,  
           	          label: "Node #{e_node_id}", 
           	          x: Random.rand(1-6664664646),
           	          y: Random.rand(1-6664664646),
           	          size: Random.rand(1-6664664646),
           	          color: color_prop,
           	          properties: {
           	          	node: e_node.props,
           	          	edge: edge_properties
           	          },
           	          relation: edge_relation

           	      }
            end
           @groups[:edges] << {
					   id: "e #{r.neo_id}",
					   source: "#{s_node_id}",
					   target: "#{e_node_id}",
					   size: Random.rand(1-6664664646),
					   color: '#ccc'
                     }
		 end

		 @groups[:nodes] << {
           	          id: current_user.id.to_s,  
           	          label: "Node #{current_user.id}", 
           	          x: Random.rand(1-6664664646),
           	          y: Random.rand(1-6664664646),
           	          size: Random.rand(1-6664664646),
           	          color: current_user.props[:color].present? ? current_user.props[:color] : '#666',
           	          properties: {
           	             node: current_user.props           	          	
           	          }
           	          # properties: current_user.props
           	          
           	      }


        # rel_type = current_user.rels(dir: :outgoing)[5].load_resource["type"]

		 
		
	end

	def new

	end

	def edit
	end

	def create		
		relation_type = params["relationship"]["type"].try(:parameterize).try(:underscore)
		# start_node = Neo4j::Node.create(get_properties(params["start_node"]))
		end_node = Neo4j::Node.create(get_properties(params["end_node"]))
		relation_properties = get_properties(params["relationship"])
		test_node = current_identity.create_rel(relation_type,  end_node, relation_properties)
		
		redirect_to groups_path(identity: current_identity.uuid)
	end

	private 

	def get_properties(prop_params)
		hash_props = {}
		prop_params.map do |property| 
		  if property[1]["name"].present? 
		  	prop_name = property[1]["name"].try(:parameterize).try(:underscore)
			hash_props[prop_name] = property[1]["value"]  
		  end
		end
		return hash_props
	end
end
