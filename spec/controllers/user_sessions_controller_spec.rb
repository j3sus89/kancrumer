require_relative '../spec_helper'

describe UserSessionsController, :type => :controller  do

  let(:valid_attributes) { { email: "useur@user.com", password: "123456"} }

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @user.activate!
  end


  describe "GET 'new'" do
    context "when not logged in" do
      it "returns a new empty user" do
        get :new
        assigns(:user).should be_a_new(User)
      end
    end

    context "when logged in" do
      it "redirects to root path and shows notice" do
        login_user(@user)
        get :new
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end

    end
  end


  describe "POST 'create'" do
    context "when user exits and wrong password" do
      it "does not log in, notices and redirects" do 
        post :create, { email: "useur@user.com", password: "111116"}
        controller.should_not be_logged_in 
        flash[:alert].should_not be_nil
        expect(response).to render_template("new")
      end
    end

    context "when user exists and right password" do
      describe "with right email" do
        it "logs in, redirects to root_path and shows notice" do
          post :create, valid_attributes
          controller.should be_logged_in 
          controller.current_user.name.should.eql?(@user.name) 
          expect(response).to redirect_to(projects_path)
          flash[:notice].should_not be_nil
        end
      end
      describe "with wrong email" do
        it "does not log in" do 
          post :create, { user_session: { email: "pepe@pepe.com", password: "123456" } }
          flash[:alert].should_not be_nil
          expect(response).to render_template("new")
        end
      end
    end
  end


  describe "GET 'destroy'" do
    it "destroys the session" do
      login_user(@user)
      controller.should be_logged_in  
      controller.current_user.should == @user
      delete :destroy
      controller.should_not be_logged_in  
      controller.current_user.should be_nil
      expect(response).to redirect_to(root_path)
      flash[:notice].should_not be_nil
    end
  end
end
