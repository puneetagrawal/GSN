require 'spec_helper'
describe "node_types" do
	subject { page }
     
  describe "Index page" do
    before(:each) do
       create_user_identity                
       sign_in(@identity, 'normal')
       visit node_types_path       
    end      
    it { page.should have_link('Create new node-type', href: new_node_type_path) }
    it { page.should have_selector('h2') }
    it { page.should have_selector('ul') }
    it { page.should have_selector('li') }
  end

    describe "New page" do
    	before(:each) do
    	   create_user_identity                
           sign_in(@identity, 'normal')
           visit node_types_path 		
    	end      
      it { page.should have_selector('div') }
      # it "should display node attributes" do           
           # should have_selector("name")
           # select "attr_type", :from => "#{NodeAttribute::ATTRIBUTE_TYPES[0]}"               
      #      click_button "Create node type"
      # end
  	end
end