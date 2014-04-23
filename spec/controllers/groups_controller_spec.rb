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

  #   describe 'GET #new' do
  #   	before do
	 #      create_user_identity
	 #      sign_in(@identity, 'normal')
	 #      visit new_group_path
	 #    end
		# let(:get_new) { get :new }
  #       @group = Group.new
  #       @node_types = NodeType.all
		# describe 'response' do
	 #    	before { get_new }
  #           it { should render_template :new }
	 #    end
  #   end

    #  describe 'POST #create' do
    #   before do
    #      create_user_identity
    #      sign_in(@identity, 'normal')
    #      # visit groups_path(identity: @identity.uuid)
    #   end
    #   let(:post_create) { post :create }
    #     @group = Group.new
    #     # @node_types = NodeType.all
    #   describe 'response' do
    #     before { post_create }
    #     it { response.should redirect_to groups_path }        
    #         # it { should render_template :new }
    #   end
    # end
end
