class GroupsController < ApplicationController

	def index
		# @groups = Group.all
         @groups = {}
         @groups[:nodes] = []
         @groups[:edges] = []		 
		 check_node = []

		 # random_num = Random.rand(1-6664664646)
		 rel_users = current_user.rels(dir: :outgoing)
		 rel_users.each do |r|
         
		   e_node = r.end_node
		   e_node_id = r.end_node.neo_id
		   s_node_id = r.start_node.neo_id
           unless check_node.include? e_node_id
           	 check_node << e_node_id
             @groups[:nodes] << {
           	          id: e_node_id.to_s,  
           	          label: "Node #{e_node_id}", 
           	          x: Random.rand(1-6664664646),
           	          y: Random.rand(1-6664664646),
           	          size: Random.rand(1-6664664646),
           	          color: '#666'
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
           	          color: '#666'
           	      }


        # rel_type = current_user.rels(dir: :outgoing)[5].load_resource["type"]

		 
		
	end

	def new

	end

	def edit
	end

	def create		
		relation_type = params["relationship"]["type"]
		# start_node = Neo4j::Node.create(get_properties(params["start_node"]))
		end_node = Neo4j::Node.create(get_properties(params["end_node"]))
		relation_properties = get_properties(params["relationship"])
		test_node = current_user.create_rel(relation_type,  end_node, relation_properties)
		
		redirect_to groups_path
	end

	private 

	def get_properties(prop_params)
		hash_props = {}
		prop_params.map{|property| hash_props[property[1]["name"]] = property[1]["value"] if property[1]["name"].present? }
		return hash_props
	end
end
