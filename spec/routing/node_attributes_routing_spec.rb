require "spec_helper"

describe NodeAttributesController do
  describe "routing" do

    it "routes to #index" do
      get("/node_attributes").should route_to("node_attributes#index")
    end

    it "routes to #new" do
      get("/node_attributes/new").should route_to("node_attributes#new")
    end

    it "routes to #create" do
      post("/node_attributes").should route_to("node_attributes#create")
    end
  end
end
