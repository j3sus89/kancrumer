require_relative '../spec_helper'

describe UserStoriesController, :type => :controller do

  let(:valid_attributes) { { title: "UserStoryTitle", description: "UserStoryDescription", estado: 0, code:"ACD", effort: 4 } }

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @user2 = FactoryGirl.create(:usuario2)
    @project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user2.id)
    @sprint = FactoryGirl.create(:sprint1, project: @project)
    @us1 = FactoryGirl.create(:userStory1, sprint: @sprint)
    @us2 = FactoryGirl.create(:userStory2, sprint: @sprint)
  end


  describe "GET index" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "lists all sprints as @sprints for a specific project" do
        login_user(@user)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        expect(response).to redirect_to(project_sprint_path(@sprint.project, @sprint))
      end
    end

    context "when user is an admin" do
      it "lists all sprints as @sprints for a specific project" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        expect(response).to redirect_to(project_sprint_path(@sprint.project, @sprint))
      end
    end

    context "when user is a product owner" do
      it "lists all sprints as @sprints for a specific project" do
        login_user(@user2)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        expect(response).to redirect_to(project_sprint_path(@sprint.project, @sprint))
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "lists all sprints as @sprints for a specific project" do
        projectSM = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        login_user(@user)
        get :index, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param} 
        expect(response).to redirect_to(project_sprint_path(sprintSM.project, sprintSM))
      end
    end
  end


  describe "GET show" do
    context "when user is NOT an admin or user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "shows the specific user story" do
        login_user(@user)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        assigns(:user_story).should eq(@us1)
      end
    end

    context "when user is an admin" do
      it "shows the specific user story" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        assigns(:user_story).should eq(@us1)
      end
    end

    context "when user is a product owner" do
      it "shows the specific user story" do
        login_user(@user2)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        assigns(:user_story).should eq(@us1)
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "shows the specific user story" do
        projectSM = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        login_user(@user)
        get :show, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param, :id => usSM.to_param} 
        assigns(:user_story).should eq(usSM)
      end
    end
  end


  describe "GET new" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to sprint project path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param}
        expect(response).to redirect_to(project_sprint_path(@sprint.project, @sprint))
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "gets a new user story for the sprint" do
        login_user(@user)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        assigns(:user_story).should be_a_new(UserStory)
      end
    end

    context "when user is an admin" do
      it "gets a new user story for the sprint" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        assigns(:user_story).should be_a_new(UserStory)
      end
    end

    context "when user is a product owner" do
      it "gets a new user story for the sprint" do
        login_user(@user2)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param} 
        assigns(:user_story).should be_a_new(UserStory)
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "redirects to sprint project path and notice" do
        projectSM = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id,  user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        login_user(@user)
        get :new, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param} 
        expect(response).to redirect_to(project_sprint_path(sprintSM.project, sprintSM))
        flash[:notice].should_not be_nil
      end
    end
  end


  describe "GET edit" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        expect(response).to redirect_to(project_sprint_path(@sprint.project, @sprint))
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "edits the user story requested" do
        login_user(@user)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        assigns(:user_story).should eq(@us1)
      end
    end

    context "when user is an admin" do
      it "edits the user story requested" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        assigns(:user_story).should eq(@us1)
      end
    end

    context "when user is a product owner" do
      it "edits the user story requested" do
        login_user(@user2)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param} 
        assigns(:user_story).should eq(@us1)
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "redirects to projects path and notice" do
        projectSM = FactoryGirl.create(:project1,  scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        login_user(@user)
        get :edit, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param, :id => usSM.to_param} 
        expect(response).to redirect_to(project_sprint_path(sprintSM.project, sprintSM))
        flash[:notice].should_not be_nil
      end
    end
  end


  describe "POST create" do
    context "with valid params" do
      it "creates an user story" do
        login_user(@user)
        expect {
        post :create, { project_id: @project.id, sprint_id: @sprint.id, user_story: @us1.attributes }
        }.to change(UserStory, :count).by(0)
        assigns(:user_story).should be_a(UserStory)
        assigns(:user_story).should be_persisted
        response.should redirect_to(UserStory.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user_story as @user_story and redirects to new template" do
        login_user(@user)
        UserStory.any_instance.stub(:save).and_return(false)
        post :create, {project_id: @project.id, sprint_id: @sprint.id, user_story: { "title" => "invalid value" }}
        assigns(:user_story).should be_a_new(UserStory)
        response.should render_template("new")
      end
    end
  end


  describe "PUT update" do
    context "with valid params" do
      it "updates the requested user_story" do
        login_user(@user)
        UserStory.any_instance.should_receive(:update).with({ "title" => "" })
        put :update, {project_id: @project.id, sprint_id: @sprint.id, :id => @us1.to_param, :user_story => { "title" => "" }}
      end
      it "assigns the requested user_story as @user_story" do
        login_user(@user)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, :id => @us1.to_param, :user_story => valid_attributes}
        assigns(:user_story).should eq(@us1)
      end
      it "redirects to the user_story" do
        login_user(@user)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, :id => @us1.to_param, :user_story => valid_attributes}
        response.should redirect_to(project_sprint_user_story_path)
      end
    end

    context "with invalid params" do
      it "assigns the user_story as @user_story" do
        login_user(@user)
        UserStory.any_instance.stub(:save).and_return(false)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, :id => @us1.to_param, :user_story => { "title" => "invalid value" }}
        assigns(:user_story).should eq(@us1)
      end
      it "re-renders the 'edit' template" do
        login_user(@user)
        UserStory.any_instance.stub(:save).and_return(false)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, :id => @us1.to_param, :user_story => { "title" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested user_story" do
      login_user(@user)
      expect {
        delete :destroy, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param}
      }.to change(UserStory, :count).by(0)
    end
    it "redirects to the user_stories list" do
      login_user(@user)
      delete :destroy, {project_id:  @project.to_param, sprint_id: @sprint.to_param, :id => @us1.to_param}
      response.should redirect_to(project_sprint_user_stories_path)
    end
  end

end
