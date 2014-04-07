require "spec_helper"

describe ServicesController do
  describe "routing" do

    it "routes to #create" do
      get("/auth/facebook/callback").should route_to("services#create", provider: "facebook")
      post("/auth/facebook/callback").should route_to("services#create", provider: "facebook")
    end   

  
  end
end
