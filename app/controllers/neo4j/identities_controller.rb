class Neo4j::IdentitiesController < ApplicationController
	before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

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
     rel_identities.each do |r|
         
       e_node = r.end_node
       e_node_id = r.end_node.neo_id
       s_node_id = r.start_node.neo_id
       edge_properties = r.props
       edge_relation = r.load_resource.present? ? r.load_resource["type"] : ""
       color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'
       # Rails.logger.debug edge       
           unless check_node.include? e_node_id
             check_node << e_node_id
             @providers[:nodes] << {
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
           @providers[:edges] << {
             id: "e #{r.neo_id}",
             source: "#{s_node_id}",
             target: "#{e_node_id}",
             size: Random.rand(1-6664664646),
             color: '#ccc'
                     }
     end

     @providers[:nodes] << {
                      id: @identity.id.to_s,  
                      label: "Node #{@identity.id}", 
                      x: Random.rand(1-6664664646),
                      y: Random.rand(1-6664664646),
                      size: Random.rand(1-6664664646),
                      color: '#FF0000',
                      properties: {
                         node: @identity.props                         
                      }
                      
                  }

     @providers[:edges] << {
             id: "#{@identity.rels(type: 'User#identities')[0].neo_id}",
             source: "#{current_user.id}",
             target: "#{@identity.id}",
             size: Random.rand(1-6664664646),
             color: '#ccc'
                     }             
     @providers[:nodes] <<  {
                      id: current_user.id.to_s,  
                      label: "Node #{current_user.id}", 
                      x: Random.rand(1-6664664646),
                      y: Random.rand(1-6664664646),
                      size: Random.rand(1-6664664646),
                      color: '#00FF00',
                      properties: {
                         node: current_user.props                         
                      }
                      
                  }


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
        flash[:notice] = "Please verify your email"
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
    redirect_to identities_url
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
      params.require(:neo4j_identity).permit(:name, :email, :password,
                                   :password_confirmation, :first_name, :last_name, :provider, :country)
    end

    # Before filters

    def correct_user
      @identity = Neo4j::Identity.find(params[:id])
      redirect_to(root_url) unless current_user?(@identity)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin
    end
    
end
