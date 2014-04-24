class GroupTypesController < ApplicationController

	def index		
      # GroupType.all.each_with_index do |grp, index| 
      #   grp.node_types.each do |nt|  
      #   end 
      # end
         @group_type = GroupType.all.map{|gt| gt}[0]
         @groups = {}
         @groups[:nodes] = []
         @groups[:edges] = []
         if @group_type.present?		 
			 check_node_type = []
			 check_node_attr = []
	         
			 # random_num = Random.rand(1-6664664646)
			 rel_group_types = @group_type.rels(dir: :outgoing)
			 rel_group_types.each do |r|
	           
			   e_node = r.end_node
			   e_node_id = r.end_node.neo_id
			   s_node_id = r.start_node.neo_id
			   edge_properties = r.props
			   edge_relation = r.load_resource.present? ? r.load_resource["type"] : ""
			   color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'
			   # Rails.logger.debug edge		   
	           unless check_node_type.include? e_node_id
	           	 check_node_type << e_node_id
	             @groups[:nodes] << {
	           	          id: e_node_id.to_s,  
	           	          label: "NodeType #{e_node_id}", 
	           	          x: Random.rand(1-6664664646),
	           	          y: Random.rand(1-6664664646),
	           	          size: Random.rand(1-6664664646),
	           	          color: "#1928F8",
	           	          properties: {
	           	          	node: e_node.props,
	           	          	edge: edge_properties
	           	          },
	           	          relation: edge_relation

	           	      }

	              
	              rel_node_types = r.end_node.rels(dir: :outgoing)
	          

	           
	           rel_node_types.each do |rel_nt|
	               
				   e_node_nt = rel_nt.end_node
				   e_node_nt_id = rel_nt.end_node.neo_id
				   s_node_nt_id = rel_nt.start_node.neo_id
				   nt_edge_properties = rel_nt.props
				   nt_edge_relation = rel_nt.load_resource.present? ? rel_nt.load_resource["type"] : ""
				   nt_color_prop = rel_nt.end_node.props[:color].present? ? rel_nt.end_node.props[:color] : '#666'
				   # Rails.logger.debug edge		   
		           unless check_node_attr.include? e_node_nt_id
		           	 check_node_attr << e_node_nt_id
		             @groups[:nodes] << {
		           	          id: e_node_nt_id.to_s,  
		           	          label: "NodeAttr #{e_node_nt_id}", 
		           	          x: Random.rand(1-6664664646),
		           	          y: Random.rand(1-6664664646),
		           	          size: Random.rand(1-6664664646),
		           	          color: "#19E6F8",
		           	          properties: {
		           	          	node: e_node_nt.props,
		           	          	edge: nt_edge_properties
		           	          },
		           	          relation: nt_edge_relation

		           	      }
		            end
		           @groups[:edges] << {
							   id: "e #{rel_nt.neo_id}",
							   source: "#{s_node_nt_id}",
							   target: "#{e_node_nt_id}",
							   size: Random.rand(1-6664664646),
							   color: '#ccc'
		                     }

		        end 



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
	           	          label: "User #{current_user.id}", 
	           	          x: Random.rand(1-6664664646),
	           	          y: Random.rand(1-6664664646),
	           	          size: Random.rand(1-6664664646),
	           	          color: '#F81960',
	           	          properties: {
	           	             node: current_user.props           	          	
	           	          }
	           	          # properties: current_user.props
	           	          
	           	      }
	         
			 @groups[:nodes] << {
	           	          id: @group_type.neo_id.to_s,  
	           	          label: "GroupType #{@group_type.neo_id}", 
	           	          x: Random.rand(1-6664664646),
	           	          y: Random.rand(1-6664664646),
	           	          size: Random.rand(1-6664664646),
	           	          color: '#E2F819',
	           	          properties: {
	           	             node: @group_type.props           	          	
	           	          }
	           	          # properties: current_user.props
	           	          
	           	      }		

	          relation_user_gt =  @group_type.rels(type: "users", dir: :incoming, between: Neo4j::Node.load(current_user.id))[0]
	          if relation_user_gt.present?
		          @groups[:edges] << {
							   id: "e #{relation_user_gt.neo_id}",
							   source: "#{current_user.id}",
							   target: "#{@group_type.neo_id}",
							   size: Random.rand(1-6664664646),
							   color: '#ccc'
		                     }
		      end
	    end
   # binding.pry


	end

	def new
      @group_type = GroupType.new
      @node_types = NodeType.all
	end

	def edit
	end

	def create		
		
		@group_type = GroupType.new()
		if @group_type.save
		  @group_type.creator = current_user
		  if params[:node_types].present?
			  params[:node_types].each do |nt|
			  	node_type = NodeType.find(nt)
			  	@group_type.node_types << node_type if node_type.present?
			  end
		  end		  
          
		  if @group_type.node_types.present? and @group_type.has_name_desc?
		  	redirect_to group_types_path
		  else
		  	@group_type.destroy
		  	@node_types = NodeType.all
		  	flash.now[:error] = 'Group Type must contains name and description node type'
		  	render 'new'		    
		  end
		else
		  render 'new'
		end
		
	end
	

end
