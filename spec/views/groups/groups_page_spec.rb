require 'spec_helper'
describe "groups/groups_page_spec.rb" do
	subject { page }

	describe "Index page" do
    	    
    	before do
    	    create_user_identity
    	    sign_in(@identity, 'normal')
    	    visit groups_path
    	end   	

        it { page.should have_selector('table') }
        it { page.should have_link('Create groups', href: new_group_path) }
        it {page.should have_selector('table th', :count => 3) }
    end

    describe "New page" do
          
      before do
          create_user_identity
          sign_in(@identity, 'normal')
          visit new_group_path     
      end     

         it { page.should have_selector('div') }
         it { page.should have_selector('p') }
    end

   describe "Show page" do
          
      before do
          create_user_identity
          sign_in(@identity, 'normal')
          node_attribute = FactoryGirl.create(:node_attribute)
          @node_type = FactoryGirl.create(:node_type)
          @node_type.properties << node_attribute

          group = Neo4j::Node.create( {"#{@node_type.field_name}" => "hello"}, :Group )
          identity_group = @identity.create_rel(:groups, group)
          group_owner = group.create_rel(:owner, @identity)
          visit group_path(group.neo_id)     
      end     

         it { page.should have_selector('div') }
         it { page.should have_css('#graph-container') }
    end

end