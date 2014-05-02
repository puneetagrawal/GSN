class GroupsController < ApplicationController
    include CustomNodeRelationship

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
		params[:node_types][:color] = "#FF00FF"
		group = Neo4j::Node.create(params[:node_types], :Group)

        # group.creator = current_user
        # group.owner = current_user
		# binding.pry
		# relation_properties = get_properties(params["relationship"])
		identity_group = current_identity.create_rel(:groups, group)
        group_owner = group.create_rel(:is_owned_by, current_identity)
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
     @groups = {}
     @groups[:nodes] = []
     @groups[:edges] = []
     
	   e_node = @group
	   s_node = current_identity

	   e_relation = @group.rels(type: :groups, dir: :incoming, between: Neo4j::Node.load(current_identity.id))[0]	
	   # edge_relation = e_relation.load_resource.present? ? e_relation.load_resource["type"] : ""
	   e_relation_user = current_identity.rels(type: "User#identities", dir: :incoming, between: Neo4j::Node.load(current_user.id))[0]
	   # color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'

     @groups[:nodes] << create_node(node: e_node, relation: "groups", label: "Group", color: "#666")
     @groups[:nodes] << create_node(node: s_node, relation: "groups", label: "Identity", color: "#19F8B5")
     @groups[:nodes] << create_node(node: current_user, label: "User", color: "#F81960")
     @groups[:edges] << create_edge(source: s_node, target: e_node, relation: e_relation, color: '#ccc')
     @groups[:edges] << create_edge(source: current_user, target: s_node, relation: e_relation_user, color: '#ccc')
     @check_node = [e_node.neo_id, s_node.neo_id, current_user.neo_id]
	end

	

end
