require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "routes to #new" do
      get("/signin").should route_to("sessions#new")
    end

    it "routes to #create" do
      post("/sessions").should route_to("sessions#create")
    end

    it "routes to #destroy" do
      delete("/signout").should route_to("sessions#destroy")
    end

    it "routes to #confirm_user" do
      get("/confirm_user/122123132").should route_to("sessions#confirm_user", :token => "122123132")
    end

  end
end
