require "spec_helper"

describe StaticPagesController do
  describe "routing" do

    it "routes to #new" do
      get("/home").should route_to("static_pages#home")
    end

  end
end
