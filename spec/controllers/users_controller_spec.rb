require 'spec_helper'

describe UsersController do
  # let(:user) { FactoryGirl.create(:user) }  
  # routes { UsersController.routes }

  before do
      create_user_identity
  end

	describe 'GET #index' do
		let(:get_index) { get :index }
        @users = User.all
    describe 'response' do
	    	before { get_index }
	        it { assigns(:users).should eql @users }
    end
  end

  describe 'GET #show' do
    before do
      @identity = Neo4j::Identity.last
      user_sign_in(@identity)
    end
    it "should show the user" do
      get :show, id: @user.id
      assigns(:user).should == @user
    end
 	end

 	describe 'GET #new' do
	  let(:get_new) { get :new }
    @user = User.new
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
    it "should edit the user" do
      get :edit, id: @user.id
      assigns(:user).should == @user
    end
  end

   describe 'PUT update' do
     before do
       @identity = Neo4j::Identity.last
       user_sign_in(@identity)
     end
     it "should update the user" do
       # put :update, id: @user.id
       # assigns(:user).should == @user
 
       patch :update, id: @user.id, user: {name: "test233"}
       assert_redirected_to user_path(assigns(:user))
     end
  end
  
  describe "should destroy user" do  
 

    it "should destroy the identities if the user is destroyed" do
        idenitities = @user.identities.map{|identity| identity}
        @user.destroy
        idenitities.each do |identity|
          identity.should_not exist_in_database
        end
    end

    it "should destroy the user" do
        @user.destroy
        @user.should_not exist_in_database
       
    end

  end




end
