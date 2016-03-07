require_relative "../spec_helper"

describe UserSessionsController, :type => :routing do
  describe "routing" do

    it "routes to /login" do
      get("/login").should route_to("user_sessions#new")
    end

    it "routes to /logout" do
    	post("/logout").should route_to("user_sessions#destroy")
    end

    it "routes to #new" do
       get("/user_sessions/new").should route_to("user_sessions#new")
    end

    it "does not route to #create" do
      post("/user_sessions").should_not route_to("user_sessions#create")
    end

    it "routes to #destroy" do
      delete("/user_sessions/1").should route_to("user_sessions#destroy", :id => "1")
    end

  end
end