require 'spec_helper'

describe Neo4j::IdentitiesController do

	before(:each) do
	  create_user_identity
    end

	describe 'GET #index' do
		let(:get_index) { get :index }
        @identities = Neo4j::Identity.all
		describe 'response' do
	    	before { get_index }
	        it { assigns(:identities).should eql @identities }
        end
    end

    describe 'GET #new' do
		let(:get_new) { get :new }
        @user = Neo4j::Identity.new
		describe 'response' do
	    	before { get_new }
            it { should render_template :new }
	    end
    end

    describe 'GET #edit' do
    	before do
        	@identity = Neo4j::Identity.last
        	user_sign_in(@identity)
      	end
     	it "should edit the identity" do
        	get :edit, id: @identity.id
        	assigns(:identity).should == @identity
     	end
    end

    describe 'GET #show' do
    	before do
    	  	@identity = Neo4j::Identity.last
    	  	user_sign_in(@identity)
    	end
    	it "should show the identity" do   
	        get :show, id: @identity.id
    	    assigns(:identity).should eq(@identity)        
     	end
    end

    describe 'PUT update' do
      before do
        @identity = Neo4j::Identity.last
        user_sign_in(@identity)
      end
      it "should update the identity" do
        # put :update, id: @user.id
        # assigns(:user).should == @user
  
        patch :update, id: @identity.id, identity: {country: "UK"}
        # assert_redirected_to neo4j_identity_path(assigns(:identity))
        # assert_redirected_to "/neo4j/identities/#{@identity.id}"
      end
    end
  
    describe "should destroy identity" do

      # it "should destroy the identities if the user is destroyed" do
      #     idenitities = @user.identities.map{|identity| identity}
      #     @user.destroy
      #     idenitities.each do |identity|
      #       identity.should_not exist_in_database
      #     end
      # end

      it "should destroy the identity" do
          @identity.destroy
          @identity.should_not exist_in_database
      end

    end

end
