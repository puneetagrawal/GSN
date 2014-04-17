# require 'spec_helper'
# describe "users" do
# 	subject { page }
    
     
#     describe "Edit page" do
#     	before do
#     	    create_user_identity
#     	    # sign_in(@identity, 'normal')			
    					
#     	end 

#         describe "Page content" do
#             before do 
#                 sign_in(@identity, 'normal')
#                 visit edit_user_path(@user)
#             end    

#         	it { page.should have_link( 'change', href: "http://gravatar.com/emails") }

#             it "user's profile changes" do      			
#     		    fill_in "First name", :with => "Test"
#     		    fill_in "Last name", :with => "User"		    
#     		    fill_in "Country", :with => "India"		    
    		    
#     		    click_button "Save changes"
#     		    page.should have_content('Profile updated')
#     		end
#         end
#   	end
# end
