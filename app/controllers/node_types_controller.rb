class NodeTypesController < ApplicationController

	def index
		@node_types = NodeType.all
	end

	def new
		@node_type = NodeType.new
		hash_attributes = {}
    	attributes = NodeAttribute.all
    	attributes.each do |attr|
    	  hash_attributes[attr.attr_type] = []  unless hash_attributes.has_key? attr.attr_type
    	  hash_attributes[attr.attr_type] << [attr.name, attr.id]
    	end
    	@attributes = hash_attributes
	end

	def create
		@node_type = NodeType.new(node_type_params)				
		if @node_type.save
		  @node_type.creator = current_user
		  params["node_attr_type"].each do |key, val|
		  	
		  	if val.present?
			  	property = NodeAttribute.find(val)
			    @node_type.properties << property
			end
		  end
		  
		  redirect_to node_types_path(identity: current_identity.uuid)
		else
		  render 'new'
		end
	end
   
   private

	def node_type_params
	  params.require(:node_type).permit(:field_name)
	end

	
end
