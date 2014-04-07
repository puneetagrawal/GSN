require "spec_helper"

describe Neo4j::IdentitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/neo4j/identities").should route_to("neo4j/identities#index")
    end

    it "routes to #new" do
      get("/signup").should route_to("neo4j/identities#new")
    end

    it "routes to #show" do
      get("/neo4j/identities/1").should route_to("neo4j/identities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/neo4j/identities/1/edit").should route_to("neo4j/identities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/neo4j/identities").should route_to("neo4j/identities#create")
    end

    it "routes to #update" do
      put("/neo4j/identities/1").should route_to("neo4j/identities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/neo4j/identities/1").should route_to("neo4j/identities#destroy", :id => "1")
    end
  end
end
