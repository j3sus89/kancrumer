require_relative '../spec_helper'

describe CommentsController, :type => :controller do

  let(:valid_attributes) { { body: "This is the comment...", user: "52a779444a657303b9010000", date: "March 17th, 2014 19:44" } }

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @user2 = FactoryGirl.create(:usuario2)
    @project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user2.id)
    @sprint = FactoryGirl.create(:sprint1, project: @project)
    @us1 = FactoryGirl.create(:userStory1, sprint: @sprint)
    @comment = FactoryGirl.create(:comment1, user: @user.id, user_story: @us1)
  end

  describe "GET index" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        puts controller.current_user
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "lists all comments for a specific user story" do
        login_user(@user)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        expect(response).to redirect_to(project_sprint_user_story_path(@us1.sprint.project, @us1.sprint, @us1))
      end
    end

    context "when user is an admin" do
      it "lists all comments for a specific user story" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        expect(response).to redirect_to(project_sprint_user_story_path(@us1.sprint.project, @us1.sprint, @us1))
      end
    end

    context "when user is a product owner" do
      it "lists all comments for a specific user story" do
        login_user(@user2)
        get :index, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        expect(response).to redirect_to(project_sprint_user_story_path(@us1.sprint.project, @us1.sprint, @us1))
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "lists all comments for a specific user story" do
        projectSM = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        login_user(@user)
        get :index, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param, user_story_id: usSM.to_param} 
        expect(response).to redirect_to(project_sprint_user_story_path(usSM.sprint.project, usSM.sprint, usSM))
      end
    end
  end


  describe "GET show" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, :id => @comment.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "shows the specific comment" do
        login_user(@user)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, :id => @comment.to_param} 
        assigns(:comment).should eq(@comment)
      end
    end

    context "when user is an admin" do
      it "shows the specific comment" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, :id => @comment.to_param} 
        assigns(:comment).should eq(@comment)
      end
    end

    context "when user is a product owner" do
      it "shows the specific comment" do
        login_user(@user2)
        get :show, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, :id => @comment.to_param} 
        assigns(:comment).should eq(@comment)
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "shows the specific comment" do
        projectSM = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        commentSM = FactoryGirl.create(:comment1, user: @user.id, user_story: usSM)
        login_user(@user)
        get :show, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param, user_story_id: usSM.to_param, :id => commentSM.to_param} 
        assigns(:comment).should eq(commentSM)
      end
    end
  end


  describe "GET new" do
    context "when user is NOT an admin and user does NOT belong to the project" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is a scrum master" do
      it "gets a new comment for the user story" do
        login_user(@user)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        assigns(:comment).should be_a_new(Comment)
      end
    end

    context "when user is an admin" do
      it "gets a new comment for the user story" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :new, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param} 
        assigns(:comment).should be_a_new(Comment)
      end
    end

    context "when user is a product owner" do
      it "gets a new comment for the user story" do
        login_user(@user2)
        get :new, {project_id: @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param } 
        assigns(:comment).should be_a_new(Comment)
      end
    end

    context "when user belongs to the project as scrumMember" do
      it "gets a new comment for the user story" do
        projectSM = FactoryGirl.create(:project1, scrumMaster: @user2.id, productOwner: @user2.id, user_ids: [@user.id])
        sprintSM = FactoryGirl.create(:sprint1, project: projectSM)
        usSM = FactoryGirl.create(:userStory1, sprint: sprintSM)
        login_user(@user)
        get :new, {project_id:  projectSM.to_param, sprint_id: sprintSM.to_param, user_story_id: usSM.to_param } 
        assigns(:comment).should be_a_new(Comment)
      end
    end
  end


  describe "GET edit" do
    context "when user is NOT an admin and user is NOT the author" do
      it "redirects to projects path and notice" do
        user3 = FactoryGirl.create(:usuario3)
        login_user(user3)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, id: @comment.to_param} 
        expect(response).to redirect_to(root_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is the author" do
      it "edits the comment requested" do
        login_user(@user)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, id: @comment.to_param} 
        assigns(:comment).should eq(@comment)
      end
    end

    context "when user is an admin" do
      it "edits the comment requested" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :edit, {project_id:  @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, id: @comment.to_param} 
        assigns(:comment).should eq(@comment)
      end
    end
  end


  describe "POST create" do
    context "with valid params" do
      it "creates a comment" do
        login_user(@user)
        expect {
          post :create, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, comment: valid_attributes}
        }.to change(Comment, :count).by(0)
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
        response.should redirect_to(Comment.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment and redirects to new template" do
        login_user(@user)
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, comment: { "title" => "invalid value" }}
        assigns(:comment).should be_a_new(Comment)
        response.should render_template("new")
      end
    end
  end


  describe "PUT update" do
    context "with valid params" do
      it "updates the requested comment" do
        login_user(@user)
        Comment.any_instance.should_receive(:update).with({ "body" => "MyString" })
        put :update, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, id: @comment.to_param, comment: { body: "MyString" }}
      end
      it "assigns the requested comment as @comment" do
        login_user(@user)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, id: @comment.to_param, comment: valid_attributes}
        assigns(:comment).should eq(@comment)
      end
      it "redirects to the comment" do
        login_user(@user)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, id: @comment.to_param, comment: valid_attributes}
        response.should redirect_to(project_sprint_user_story_comments_path)
      end
    end

    context "with invalid params" do
      it "assigns the comment as @comment" do
        login_user(@user)
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, id: @comment.to_param, comment: { body: "invalid value" }}
        assigns(:comment).should eq(@comment)
      end
      it "re-renders the 'edit' template" do
        login_user(@user)
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {project_id: @project.id, sprint_id: @sprint.id, user_story_id: @us1.id, id: @comment.to_param, comment: { body: "invalid value" }}
        response.should render_template("edit")
      end
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested comment" do
      login_user(@user)
      expect {
        delete :destroy, {project_id: @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, id: @comment.to_param}
      }.to change(Comment, :count).by(0)
    end
    it "redirects to the comments list" do
      login_user(@user)
      delete :destroy, {project_id: @project.to_param, sprint_id: @sprint.to_param, user_story_id: @us1.to_param, id: @comment.to_param}
      response.should redirect_to(redirect_to(project_sprint_user_story_comments_path))
    end
  end
end
