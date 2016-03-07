require_relative '../spec_helper'

describe UsersController, :type => :controller do

  let(:valid_attributes) { { "name" => "user", "role" => "user", "email" => "user@email.com", "password" => "12345678", "password_confirmation" => "12345678" } }
  
  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @admin = FactoryGirl.create(:administrador)
  end



  describe "GET index" do
    it "assigns all users" do
        login_user(@admin)
        get :index, {}
        assigns(:users).should include(@admin)
      end   
  end



  describe "GET show" do
    context "when user is an admin" do
      it "it gets the requested user" do
        login_user(@admin)
        get :show, {:id => @user.to_param}
        assigns(:user).should eq(@user)
      end
    end

    context "when user is NOT an admin and asks for another user" do
      it "it does not get the requested user and redirects" do
        user2 = FactoryGirl.create(:usuario2)
        login_user(@user)
        get :show, {:id => user2.to_param}
        expect(response).to redirect_to(user_path(@user))
      end
    end

    context "when user is NOT an admin and ask for himself" do
      it "it gets the requested user" do
      login_user(@user)
      get :show, {:id => @user.to_param}
      assigns(:user).should eq(@user)
    end
    end
  end



  describe "GET new" do
    context "when not logged in" do
      it "assigns a new user as @user" do
        get :new, {}
        assigns(:user).should be_a_new(User)
      end
    end

    context "when logged in" do
      it "redirects to edit user path and shows notice" do
        login_user(@user)
        get :new, {}
        expect(response).to redirect_to(edit_user_path(@user))
        flash[:notice].should_not be_nil
      end
    end
  end



  describe "GET edit" do
    it "redirects to show action" do
      login_user(@user)
      get :edit, {:id => @user.to_param}
      expect(response).to redirect_to(user_path(@user))
    end
  end



  describe "POST create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes}
          }.to change(User, :count).by(1)
      end
      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end
      it "redirects to the created user" do
        post :create, {:user => valid_attributes}
        response.should redirect_to(User.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { "name" => "invalid value" }}
        assigns(:user).should be_a_new(User)
      end
      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end



  describe "PUT update" do

    context "when valid params and admin tries to update their role having one admin" do
      it "doesn't update and redirects" do
        login_user(@admin)
        put :update, { :id => @admin.to_param, :user => { "role" => "user" }}
        expect(response).to redirect_to(user_path(@admin))
        flash[:notice].should_not be_nil
      end
    end

    context "with valid params and having several admins" do
      it "updates the requested user" do
        login_user(@user)
        User.any_instance.should_receive(:update).with({ "name" => "MString" })
        put :update, {:id => @user.to_param, :user => { "name" => "MString" }}
      end
      it "assigns the requested user as @user" do
        login_user(@user)
        put :update, {:id => @user.to_param, :user => valid_attributes}
        assigns(:user).should eq(@user)
      end
      it "redirects to the user" do
        login_user(@user)
        put :update, {:id => @user.to_param, :user => valid_attributes}
        response.should redirect_to(@user)
      end
    end

    context "with invalid params and having several admins" do
      it "assigns the user as @user" do
        login_user(@user)
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => @user.to_param, :user => { "name" => "invalid value" }}
        assigns(:user).should eq(@user)
      end
      it "re-renders the 'edit' template" do
        login_user(@user)
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => @user.to_param, :user => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end



  describe "DELETE destroy" do

    context "when user is scrum master" do
      it "doesn't destroy the user because has projects, redirects to the users list and notice" do
      login_user(@user)
      project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user.id)
      delete :destroy, {:id => @user.to_param}
        expect(response).to redirect_to root_path
        flash[:notice].should_not be_nil
      end
    end

    context "when user is product owner" do
      it "doesn't destroy the user because has projects, redirects to the users list and notice" do
      login_user(@user)
      project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user.id)
      delete :destroy, {:id => @user.to_param}
        expect(response).to redirect_to root_path
        flash[:notice].should_not be_nil
      end
    end

    #tests when user is NOT scrum master neither product owner

    context "when user is admin and deletes another user" do
      it "destroys the requested user and redirects to the users list" do
        login_user(@admin)
        user2 = FactoryGirl.create(:usuario2)
        expect {
          delete :destroy, {:id => user2.to_param}
          }.to change(User, :count).by(-1)
        expect(response).to redirect_to root_path
      end
    end

    context "when user is admin and tries to delete himself having just one admin" do
      it "doesn't destroy the admin, redirects to the users list and notice" do
        login_user(@admin)
        delete :destroy, {:id => @admin.to_param}
        expect(response).to redirect_to users_path
        flash[:notice].should_not be_nil
      end
    end

    context "when user is an admin and deletes himself having more than one admin" do
      it "destroys the admin, redirects to the users list and notice" do
        admin2 = FactoryGirl.create(:administrador2)
        login_user(@admin)
        expect {
          delete :destroy, {:id => admin2.to_param}
          }.to change(User, :count).by(-1)
          expect(response).to redirect_to root_path
        end
      end

    context "when user is NOT an admin and deletes himself " do
      it "destroys the requested user and redirects to root path" do
        login_user(@user)
        expect {
          delete :destroy, {:id => @user.to_param}
          }.to change(User, :count).by(-1)
        expect(response).to redirect_to root_path
      end
    end

    context "when user is NOT an admin and tries to delete another user" do
      it "doesn't destroy the requested user, redirects to the root path and notice" do
        user2 = FactoryGirl.create(:usuario2)
        login_user(@user)
        delete :destroy, {:id => user2.to_param}
        expect(response).to redirect_to root_path
        flash[:notice].should_not be_nil
      end
    end
  end
end
