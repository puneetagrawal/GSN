require 'spec_helper'

describe SessionsController do
	# before do
 #      create_user_identity
 #    end
	describe "GET #new" do
		it "should render the new page" do
		    get :new
		    response.should be_success
		    response.should render_template("new")
		end
	end

	describe "POST #create" do

		it "email and password should not match " do
		    get :new
		    response.should be_success
		    response.should render_template("new")
		end
	end
end
