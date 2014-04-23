class GroupsController < ApplicationController

	def index
		
     @groups = current_identity.groups

	# Neo4j::Session.current.find_all_nodes(:Groupss) 
		
	end

	def new
      # @group = Group.new
      group_types = GroupType.all.map{|gt| gt}[0]
      @node_types = group_types.try(:node_types)
	end

	def edit
	end

	def create		
		# relation_type = params["relationship"]["type"].try(:parameterize).try(:underscore)
		# start_node = Neo4j::Node.create(get_properties(params["start_node"]))
		group = Neo4j::Node.create(params[:node_types], :Group)

        # group.creator = current_user
        # group.owner = current_user
		# binding.pry
		# relation_properties = get_properties(params["relationship"])
		identity_group = current_identity.create_rel(:groups, group)
        group_owner = group.create_rel(:owner, current_identity)
		# @group = Group.new(name: params[:node_types][:name])
		# if @group.save
		#   @group.creator = current_user
		#   @group.owner = current_user
		#   params[:node_types].each do |key, value|
		#   	end_node = Neo4j::Node.create({key.try(:parameterize).try(:underscore) => value})
  #           @group.create_rel(:is_instance_of, end_node)
		#   end
		  redirect_to groups_path(identity: current_identity.uuid)
		# else
		#   render 'new'
		# end
		
	end

	def show
		  @group = Neo4j::Node.load(params[:id])

		# @groups = Group.all
		 identity = current_identity
         @groups = {}
         @groups[:nodes] = []
         @groups[:edges] = []		 
		 check_node = []

		 # random_num = Random.rand(1-6664664646)
		 # rel_users = identity.rels()
		 # rel_users.each do |r|
         
		   e_node = @group
		   e_node_id = @group.neo_id
		   s_node = current_identity
		   s_node_id = current_identity.id

		   e_relation = @group.rels(type: :groups, dir: :incoming, between: Neo4j::Node.load(current_identity.id))[0]	
           # s_node_id = e_relation.start_node.neo_id
		   # edge_relation = e_relation.load_resource.present? ? e_relation.load_resource["type"] : ""
		   edge_relation = "groups"
		   # color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'
		   # Rails.logger.debug edge
		   color_prop = '#666'		   
           # unless check_node.include? e_node_id
           	 # check_node << e_node_id
             @groups[:nodes] << {
           	          id: e_node_id.to_s,  
           	          label: "Group #{e_node_id}", 
           	          x: Random.rand(1-6664664646),
           	          y: Random.rand(1-6664664646),
           	          size: Random.rand(1-6664664646),
           	          color: color_prop,
           	          properties: {
           	          	node: e_node.props,
           	          	edge: {}
           	          },
           	          relation: edge_relation

           	      }

           	        @groups[:nodes] << {
           	          id: s_node_id.to_s,  
           	          label: "Identity #{s_node_id}", 
           	          x: Random.rand(1-6664664646),
           	          y: Random.rand(1-6664664646),
           	          size: Random.rand(1-6664664646),
           	          color: "#19F8B5",
           	          properties: {
           	          	node: s_node.props,
           	          	edge: {}
           	          },
           	          relation: edge_relation

           	      }		

            # end
           @groups[:edges] << {
					   id: "e #{e_relation.neo_id}",
					   source: s_node_id.to_s,
					   target: e_node_id.to_s,
					   size: Random.rand(1-6664664646),
					   color: '#ccc'
                     }
		 # end
		 

		 e_relation_user = current_identity.rels(type: "User#identities", dir: :incoming, between: Neo4j::Node.load(current_user.id))[0]

           @groups[:edges] << {
					   id: "e #{e_relation_user.neo_id}",
					   source: current_user.id.to_s,
					   target: s_node_id.to_s,
					   size: Random.rand(1-6664664646),
					   color: '#ccc'
                     }
		 @groups[:nodes] << {
           	          id: current_user.id.to_s,  
           	          label: "User #{current_user.id}", 
           	          x: Random.rand(1-6664664646),
           	          y: Random.rand(1-6664664646),
           	          size: Random.rand(1-6664664646),
           	          color: current_user.props[:color].present? ? current_user.props[:color] : '#F81960',
           	          properties: {
           	             node: current_user.props           	          	
           	          }
           	          # properties: current_user.props
           	          
           	      }

       # binding.pry	   
        # rel_type = current_user.rels(dir: :outgoing)[5].load_resource["type"]
	end

	

end
