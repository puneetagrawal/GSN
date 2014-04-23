require 'spec_helper'
describe "group_types" do
	subject { page }
    
    describe "Index page" do
    	before do
    	    create_user_identity
    	    sign_in(@identity, 'normal')			
    	    visit group_types_path				
    	end   	    

    	it { page.should have_link( 'Create group', href: new_group_type_path) }
        it { page.should have_selector('h2') }
  	end

    

    describe "New Page" do
        before do
            create_user_identity
            sign_in(@identity, 'normal')            
            visit group_types_path             
        end
        it { page.should have_selector('div') }
    end
    
end