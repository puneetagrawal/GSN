require 'spec_helper'

describe GroupsController do

  describe 'GET #index' do
		before do
	     create_user_identity
	     sign_in(@identity, 'normal')
	     visit groups_path
	 end
	let(:get_index) { get :index }
        describe 'response' do
            before { get_index }
            it { should render_template :index }
        end
	end

    describe 'GET #new' do
        before do
            create_user_identity
            sign_in(@identity, 'normal')
            visit groups_path
        end
         let(:get_new) { get :new }
        describe 'response' do
            before { get_new }
            it { should render_template :new }
        end
    end

    describe 'POST #create' do
      before do
         create_user_identity
         sign_in(@identity, 'normal')
         node_attribute = FactoryGirl.create(:node_attribute)
         @node_type = FactoryGirl.create(:node_type)
         @node_type.properties << node_attribute
      end
              
      it 'should create the group and redirect' do
        post :create, node_types: {"#{@node_type.field_name}" => "hello"}
        response.should redirect_to "/groups?identity=#{@identity.uuid}"    
        # it { should render_template :new }
      end
    end


    # describe 'GET #show' do
    #   before do
    #     create_user_identity
    #     sign_in(@identity, 'normal')
    #     visit groups_path
    #   end
    #   it "should show the group" do
    #     get :show, id: @user.id
    #     assigns(:user).should == @user
    #   end
    # end
 

    #  describe 'POST #create' do
    #   before do
    #      create_user_identity
    #      sign_in(@identity, 'normal')
    #      visit groups_path
    #   end
    #   let(:post_create) { post :create }
        
    #   describe 'response' do
    #     post :create, node_types:
    #     it { response.should redirect_to groups_path }        
    #     # it { should render_template :new }
    #   end
    # end
end
