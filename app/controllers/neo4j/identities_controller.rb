class Neo4j::IdentitiesController < ApplicationController
	before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
   @identities = Neo4j::Identity.all
  end

  def show
    @identity = Neo4j::Identity.find(params[:id])
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
                         country: params[:country]
                     )  
                     
           end 
      @identity = Neo4j::Identity.new(identity_params)
      if @identity.save
        user.identities << @identity 
        @identity.user = user          
        flash[:notice] = "Please verify your email"
        redirect_to @identity
      else
        render 'new'
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
                                   :password_confirmation, :first_name, :last_name, :provider)
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
