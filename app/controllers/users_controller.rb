class UsersController < ApplicationController
  include CustomNodeRelationship

  before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  # before_action :admin_user,     only: :destroy

  def index
   @users = User.all
  end

  def show
    @user = User.find(params[:id])
    relations = @user.rels
    @users = {}
    @users[:nodes] = []
    @users[:edges] = []
    check_node = []
    relations.each do |relation|
         
       e_node = relation.end_node
       e_node_id = relation.end_node.neo_id
       s_node = relation.start_node
       s_node_id = relation.start_node.neo_id
       edge_properties = relation.props
       edge_relation = relation.load_resource.present? ? relation.load_resource["type"] : ""
       color_prop = relation.end_node.props[:color].present? ? relation.end_node.props[:color] : '#666'
       unless check_node.include? e_node_id
         check_node << e_node_id
         @users[:nodes] << create_node(node: e_node, relation: edge_relation, label: "Identity", color: color_prop)
       end
       @users[:edges] << create_edge(source: s_node, target: e_node, relation: relation, color: '#ccc')
    end

    # @providers[:edges] << create_edge(source: current_user, target: @identity, relation: @identity.rels(type: 'User#identities')[0], color: '#ccc')
    @users[:nodes] << create_node(node: @user, label: "User", color: '#00FF00') 
  end


  def show_other_node
    node = Neo4j::Node.load(params[:id])
    @data_collections = {}
    relations = node.rels(dir: :outgoing)
    @data_collections[:nodes] = []
    @data_collections[:edges] = []
    check_end_node = []  
    check_node = []
    get_relation_data(node, @data_collections, relations, check_end_node, check_node )
  end

  def get_relation_data(node, data_collections, relations, check_end_node, check_node )
    relations.each do |relation|
         
       e_node = relation.end_node
       e_node_id = relation.end_node.neo_id
       s_node = relation.start_node
       s_node_id = relation.start_node.neo_id
       edge_properties = relation.props
       edge_relation = relation.load_resource.present? ? relation.load_resource["type"] : ""
       color_prop = relation.end_node.props[:color].present? ? relation.end_node.props[:color] : '#666'
       unless check_end_node.include? e_node_id
         check_end_node << e_node_id
         data_collections[:nodes] << create_node(node: e_node, relation: edge_relation, label: e_node.labels[0].to_s, color: color_prop)
         # end_node_rels = e_node.rels(dir: :outgoing)
         # if end_node_rels.present?
         #    get_relation_data(e_node, data_collections, end_node_rels, check_end_node, check_node )
         # end
       end 

       data_collections[:edges] << create_edge(source: s_node, target: e_node, relation: relation, color: '#ccc')
    end
    # unless check_node.include? node and check_end_node.include? node
    #   check_node << node.neo_id
      data_collections[:nodes] << create_node(node: node, label: node.labels[0].to_s, color: '#00FF00')
    # end
  end



 
  # def show
  #   @user = User.find(params[:id])
  #   @providers = {}
  #   @providers[:nodes] = []
  #   @providers[:edges] = []
  #   check_node = []
  #   # random_num = Random.rand(1-6664664646)
  #    rel_identities = @user.rels(type: :provider)
  #    rel_identities.each do |r_identity|
         
  #      e_node = r_identity.end_node
  #      e_node_id = r_identity.end_node.neo_id
  #      s_node = r_identity.start_node
  #      s_node_id = r_identity.start_node.neo_id
  #      edge_properties = r_identity.props
  #      edge_relation = r_identity.load_resource.present? ? r_identity.load_resource["type"] : ""
  #      color_prop = r_identity.end_node.props[:color].present? ? r_identity.end_node.props[:color] : '#666'
  #      unless check_node.include? e_node_id
  #        check_node << e_node_id
  #        @providers[:nodes] << create_node(node: e_node, relation: edge_relation, label: "Provider", color: color_prop)

  #      end
  #      @providers[:edges] << create_edge(source: s_node, target: e_node, relation: r_identity, color: '#ccc')
  #    end

  #    @providers[:nodes] << create_node(node: @identity, label: "Identity", color: '#FF0000')
  #    @providers[:edges] << create_edge(source: current_user, target: @identity, relation: @identity.rels(type: 'User#identities')[0], color: '#ccc')
  #    @providers[:nodes] << create_node(node: current_user, label: "User", color: '#00FF00') 

  # end




  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user, "normal")
      flash[:notice] = "Please verify your email"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

   private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :country)
    end

    # Before filters



    def correct_user
      @user = User.find(params[:id])     
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin
    end

end