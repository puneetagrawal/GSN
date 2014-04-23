require "spec_helper"

describe GroupTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/group_types").should route_to("group_types#index")
    end

    it "routes to #new" do
      get("/group_types/new").should route_to("group_types#new")
    end

    it "routes to #create" do
      post("/group_types").should route_to("group_types#create")
    end

  end
end
