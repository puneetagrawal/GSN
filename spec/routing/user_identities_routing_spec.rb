require "spec_helper"

describe UserIdentitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_identities").should route_to("user_identities#index")
    end

    it "routes to #new" do
      get("/signup").should route_to("user_identities#new")
    end

    it "routes to #show" do
      get("/user_identities/1").should route_to("user_identities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_identities/1/edit").should route_to("user_identities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_identities").should route_to("user_identities#create")
    end

    it "routes to #update" do
      put("/user_identities/1").should route_to("user_identities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_identities/1").should route_to("user_identities#destroy", :id => "1")
    end
  end
end
