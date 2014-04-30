class Neo4j::IdentitiesController < ApplicationController
  include CustomNodeRelationship

	before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  # before_action :admin_user,     only: :destroy

  def index
   @identities = Neo4j::Identity.all
  end

  def show
    @identity = Neo4j::Identity.find(params[:id])
    @providers = {}
    @providers[:nodes] = []
    @providers[:edges] = []
    check_node = []
    # random_num = Random.rand(1-6664664646)
     rel_identities = @identity.rels(type: :provider)
     rel_identities.each do |r_identity|
         
       e_node = r_identity.end_node
       e_node_id = r_identity.end_node.neo_id
       s_node = r_identity.start_node
       s_node_id = r_identity.start_node.neo_id
       edge_properties = r_identity.props
       edge_relation = r_identity.load_resource.present? ? r_identity.load_resource["type"] : ""
       color_prop = r_identity.end_node.props[:color].present? ? r_identity.end_node.props[:color] : '#666'
       unless check_node.include? e_node_id
         check_node << e_node_id
         @providers[:nodes] << create_node(node: e_node, relation: edge_relation, label: "Provider", color: color_prop)

       end
       @providers[:edges] << create_edge(source: s_node, target: e_node, relation: r_identity, color: '#ccc')
     end

     @providers[:nodes] << create_node(node: @identity, label: "Identity", color: '#FF0000')
     @providers[:edges] << create_edge(source: current_user, target: @identity, relation: @identity.rels(type: 'User#identities')[0], color: '#ccc')
     @providers[:nodes] << create_node(node: current_user, label: "User", color: '#00FF00') 

  end

  def new
    @identity = Neo4j::Identity.new
  end

  def edit
    @identity = Neo4j::Identity.find(params[:id])
  end

  def update
    @identity = Neo4j::Identity.find(params[:id])
    if @identity.update_attributes(identity_params)
      flash[:success] = "Profile updated"
      redirect_to @identity
    else
      render 'edit'
    end
  end

  def create
    # @identity = Neo4j::Identity.new(identity_params)
    # if @identity.save
    user = if signed_in?
             current_user
           else    
             User.create(first_name: params[:neo4j_identity][:first_name],
                         last_name: params[:neo4j_identity][:last_name], 
                         country: params[:neo4j_identity][:country]
                     )  
                     
           end
    @exist_identity =  Neo4j::Identity.find(email: params[:neo4j_identity][:email].downcase) 
    if @exist_identity.blank?        
      @identity = Neo4j::Identity.new(identity_params)
      if @identity.save
        user.identities << @identity 
        @identity.user = user
        @identity.identity_provider("normal")

        flash[:notice] = signed_in? ? "Identity successfully created" : "Please verify your email"        
        redirect_to @identity
      else
        render 'new'
      end
    else
      relation =  @exist_identity.identity_provider("normal")
      if relation == :error_messsage
        flash[:error] = "Identity already created"      
        redirect_to root_path
      end
    end
  end

  def destroy
    Neo4j::Identity.find(params[:id]).destroy
    flash[:success] = "Identity deleted."
    redirect_to neo4j_identities_url
  end

  def nodes
    current_user.rels
    # neo = Neography::Rest.new
    # cypher_query =  " START node = node:nodes_index(type='User')"
    # cypher_query << " RETURN ID(node), node"
    # neo.execute_query(cypher_query)["data"].collect{|n| {"id" => n[0]}.merge(n[1]["data"])}
  end  

 def edges
  # neo = Neography::Rest.new
  # cypher_query =  " START source = node:nodes_index(type='User')"
  # cypher_query << " MATCH source -[rel]-> target"
  # cypher_query << " RETURN ID(rel), ID(source), ID(target)"
  # neo.execute_query(cypher_query)["data"].collect{|n| {"id" => n[0], "source" => n[1], "target" => n[2]} }
 end

  private

    def identity_params
      params.require(:neo4j_identity).permit(:email, :password,
                                   :password_confirmation, :first_name, :last_name, :provider, :country)
    end

    # Before filters

    def correct_user
      user_id = Neo4j::Identity.find(params[:id]).user.neo_id
      user = User.find(user_id)
      redirect_to(root_url) unless current_user?(user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin
    end
    
end
