require 'spec_helper'

describe GroupTypesController do
	#  describe 'GET #index' do
	# 	before do
	#      create_user_identity
	#      sign_in(@identity, 'normal')
	#      visit group_types_path
	#  end
	
 #      it "should index the identity" do   
 #        get :index,
 #  	    # response.should redirect_to users_path        
 #   	end
	# end

	describe 'GET #index' do
		before do
	     create_user_identity
	     sign_in(@identity, 'normal')
	     visit group_types_path
	    end
		let(:get_index) { get :index }
        # @users = User.all
        describe 'response' do
	    	before { get_index }
	        it { should render_template :index }
        end
    end

	describe 'GET #new' do
		before do
		    create_user_identity
		    sign_in(@identity, 'normal')
		    visit group_types_path
	    end
	     let(:get_new) { get :new }
	    # @group_type = GroupType.new
	    describe 'response' do
	    	before { get_new }
	        it { should render_template :new }
	    end
    end

    describe 'POST #create' do
		before do
		    create_user_identity
		    sign_in(@identity, 'normal')
		    visit group_types_path
	    end
	     
	    it "should create the node attributes and redirect" do
	       post :create, node_types: {field_name: "desc" }
	       # response.should redirect_to "/node_attributes?identity=#{@identity.uuid}"
	    end
    end

end
