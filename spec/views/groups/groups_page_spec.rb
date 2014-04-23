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
        # it { page.should have_link('Show', href: group_path(group.end_node.neo_id)) }
    end



    describe "New page" do
          
      before do
          create_user_identity
          sign_in(@identity, 'normal')
          visit groups_path     
      end     

         it { page.should have_selector('div') }
        # it { page.should have_link('Create my group', href: groups_path) }
   	end

    #   describe "Show page" do
          
    #   before do
    #       create_user_identity
    #       sign_in(@identity, 'normal')
    #       visit groups_path     
    #   end     

    #      it { page.should have_selector('div') }
    #      # it { page.should have_selector('h4') }
    #      # it { page.should have_css('#graph-container') }
    # end

end