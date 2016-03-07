require_relative '../spec_helper'

describe SprintsController, :type => :controller do

  let(:valid_attributes) { {name: "Sprint 2", description: "MySprintDescription", startdate: "25-01-1989", deadline: "20-06-2014", order: 0} }

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @user2 = FactoryGirl.create(:usuario2)
    @user3 = FactoryGirl.create(:usuario3)
    @project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user2.id)
    @sprint1 = FactoryGirl.create(:sprint1, project: @project)
  end


  describe "GET index" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        login_user(@user3)
        get :index, {project_id:  @project.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is an admin" do
      it "lists all sprints as @sprints for a specific project" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :index, {project_id:  @project.to_param} 
        expect(response).to redirect_to(project_path(@project))
      end
    end

    context "when user belongs to the project as scrum master" do
      it "lists all sprints as @sprints for a specific project" do
      login_user(@user)
        get :index, {project_id:  @project.to_param} 
        expect(response).to redirect_to(project_path(@project))
      end
    end

    context "when user belongs to the project as product owner" do
      it "lists all sprints as @sprints for a specific project" do
        login_user(@user2)
        get :index, {project_id:  @project.to_param} 
        expect(response).to redirect_to(project_path(@project))
      end
    end

    context "when user belongs to the project as scrum member" do
      it "lists all sprints as @sprints for a specific project" do
        project2 = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprint2 = FactoryGirl.create(:sprint1, project: project2)
        login_user(@user)
        get :index, {project_id:  project2.to_param} 
        expect(response).to redirect_to(project_path(project2))
      end
    end
  end


  describe "GET show" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notices" do
        login_user(@user3)
        get :show, {project_id:  @project.to_param, id: @sprint1.to_param}
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is an admin" do
      it "assigns the requested sprint as @sprint" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :show, {project_id:  @project.to_param, id: @sprint1.to_param}
        assigns(:sprint).should eq(@sprint1)
      end
    end

    context "when user belongs to the project as scrum master" do
      it "assigns the requested sprint as @sprint" do
        login_user(@user)
        get :show, {project_id:  @project.to_param, id: @sprint1.to_param}
        assigns(:sprint).should eq(@sprint1)
      end
    end

    context "when user belongs to the project as product owner" do
      it "assigns the requested sprint as @sprint" do
        login_user(@user2)
        get :show, {project_id:  @project.to_param, id: @sprint1.to_param}
        assigns(:sprint).should eq(@sprint1)
      end
    end

    context "when user belongs to the project as scrum member" do
      it "assigns the requested sprint as @sprint" do
        project2 = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprint2 = FactoryGirl.create(:sprint1, project: project2)
        login_user(@user)
        get :show, {project_id:  project2.to_param, id: sprint2.to_param}
        assigns(:sprint).should eq(sprint2)
      end
    end
  end


  describe "GET new" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        login_user(@user3)
        get :new, {project_id:  @project.to_param}
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "assigns a new sprint as @sprint" do
        login_user(@user)
        get :new, {project_id:  @project.to_param}
        assigns(:sprint).should be_a_new(Sprint)
      end
    end

    context "when user is an admin" do
      it "assigns a new sprint as @sprint" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :new, {project_id:  @project.to_param}
        assigns(:sprint).should be_a_new(Sprint)
      end
    end

    context "when user is a product owner" do
      it "assigns a new sprint as @sprint" do
        login_user(@user2)
        get :new, {project_id:  @project.to_param}
        assigns(:sprint).should be_a_new(Sprint)
      end
    end
  end


  describe "GET edit" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notices" do
        login_user(@user3)
        get :edit, {project_id:  @project.to_param, id: @sprint1.to_param}
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is an admin" do
      it "assigns the requested sprint as @sprint" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :edit, {project_id:  @project.to_param, id: @sprint1.to_param}
        assigns(:sprint).should eq(@sprint1)
      end
    end

    context "when user belongs to the project as scrum master" do
      it "assigns the requested sprint as @sprint" do
        login_user(@user)
        get :edit, {project_id:  @project.to_param, id: @sprint1.to_param}
        assigns(:sprint).should eq(@sprint1)
      end
    end

    context "when user belongs to the project as product owner" do
      it "assigns the requested sprint as @sprint" do
        login_user(@user2)
        get :edit, {project_id:  @project.to_param, id: @sprint1.to_param}
        assigns(:sprint).should eq(@sprint1)
      end
    end

    context "when user belongs to the project as scrum member" do
      it "redirects to projects path and notices" do
        project2 = FactoryGirl.create(:project2, scrumMaster: @user.id, productOwner: @user.id, user_ids: [@user2.id])
        sprint2 = FactoryGirl.create(:sprint2, project: project2)
        login_user(@user2)
        get :edit, {project_id:  project2.to_param, id: sprint2.to_param}
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end
    end
  end


  describe "POST create" do
    context "with valid params" do
      it "creates a new Sprint" do
        login_user(@user)
        expect {
        post :create, { project_id: @project.id, :sprint => valid_attributes }
        }.to change(Sprint, :count).by(0)
      end
      it "assigns a newly created sprint as @sprint" do
        login_user(@user)
        post :create, { project_id: @project.id, sprint: valid_attributes }
        assigns(:sprint).should be_a(Sprint)
        assigns(:sprint).should be_persisted
      end
      it "redirects to the created sprint" do
        login_user(@user)
        post :create, { project_id: @project.id, sprint: valid_attributes }
        response.should redirect_to(Sprint.last)
      end
    end

   context "with invalid params" do
      it "assigns a newly created but unsaved sprint as @sprint" do
        login_user(@user)
        Sprint.any_instance.stub(:save).and_return(false)
        post :create, {project_id: @project.id, :sprint => { "name" => "invalid value" }}
        assigns(:sprint).should be_a_new(Sprint)
      end
      it "re-renders the 'new' template" do
        login_user(@user)
        Sprint.any_instance.stub(:save).and_return(false)
        post :create, {project_id: @project.id, :sprint => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
 end


  describe "PUT update" do
    context "with valid params" do
      it "updates the requested sprint" do
        login_user(@user)
        Sprint.any_instance.should_receive(:update).with({ "name" => "MyString"})
        put :update, {project_id: @project.id, id: @sprint1.to_param, :sprint => { "name" => "MyString" }}
      end
      it "assigns the requested sprint as @sprint" do
        login_user(@user)
        put :update, {project_id: @project.id, :id => @sprint1.to_param, :sprint => valid_attributes}
        assigns(:sprint).should eq(@sprint1)
      end
      it "redirects to the sprint" do
        login_user(@user)
        put :update, {project_id: @project.id, :id => @sprint1.to_param, :sprint => valid_attributes}
        response.should redirect_to(project_sprint_path)
      end
    end

    context "with invalid params" do
      it "assigns the sprint as @sprint" do
        login_user(@user)
        Sprint.any_instance.stub(:save).and_return(false)
        put :update, {project_id: @project.id, :id => @sprint1.to_param, :sprint => { "name" => "invalid value" }}
        assigns(:sprint).should eq(@sprint1)
      end
      it "re-renders the 'edit' template" do
        login_user(@user)
        Sprint.any_instance.stub(:save).and_return(false)
        put :update, {project_id: @project.id, :id => @sprint1.to_param, :sprint => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end


  describe "saveOrder" do
    it "updates the state of the user_stories" do
      login_user(@user)
      p = FactoryGirl.create(:project_with, scrumMaster: @user.id, productOwner: @user.id)
      sp = FactoryGirl.create(:sprint_with, project: p)
      us2 = FactoryGirl.create(:userStory2, sprint: sp)
      us1 = FactoryGirl.create(:userStory1, sprint: sp)
      put :saveOrder, { :project_id => p.id, :id => sp.id, :data => "1:"+us1.id.to_s+","+us2.id.to_s }
      Project.find(p).sprints.find(sp).user_stories.find(us2).state.should == 1
      Project.find(p).sprints.find(sp).user_stories.find(us1).state.should == 1
      response.should redirect_to(project_sprints_path)
    end
  end


  describe "DELETE destroy" do
    context "when user is an admin" do
      it "deletes the requested sprint" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        expect {
          delete :destroy, {:project_id => @project.to_param, :id => @sprint1.to_param}
          }.to change(Sprint, :count).by(0)
          response.should redirect_to(project_sprints_path)
        end
      end

    context "when user is a scrum master" do
      it "deletes the requested sprint" do
        login_user(@user)
        expect {
          delete :destroy, {:project_id => @project.to_param, :id => @sprint1.to_param}
          }.to change(Sprint, :count).by(0)
          response.should redirect_to(project_sprints_path)
        end
    end

    context "when user is NOT an admin and NEITHER a scrum master" do
      it "redirects to projects path and notice" do
        login_user(@user3)
        delete :destroy, {project_id:  @project.to_param, :id => @sprint1.to_param}
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end
    end
  end

end
