require_relative '../spec_helper'

describe WelcomeController, :type => :controller  do

  describe "GET index" do
  	context "when user has not logged in" do
    	it "shows the page index" do
    		get :index
    		response.should render_template("index")
    	end
    end

  	context "when user has logged in" do
	    it "redirects to projects path" do
	    	user = FactoryGirl.create(:usuario)
	        login_user(user)
	        get :index
	        expect(response).to redirect_to(projects_path)
	    end 
    end 
  end
  
end
