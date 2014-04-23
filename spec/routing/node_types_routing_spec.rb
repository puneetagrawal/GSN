require "spec_helper"

describe NodeTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/node_types").should route_to("node_types#index")
    end

    it "routes to #new" do
      get("/node_types/new").should route_to("node_types#new")
    end

    it "routes to #create" do
      post("/node_types").should route_to("node_types#create")
    end
  end
end
