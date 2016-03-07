require_relative '../spec_helper'

describe ProjectsController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @user2 = FactoryGirl.create(:usuario2)
    @user3 = FactoryGirl.create(:usuario3)
    login_user(@user)
    @projectPO = FactoryGirl.create(:project2, scrumMaster: @user2.id, productOwner: @user.id)
    @projectOther = FactoryGirl.create(:project1, scrumMaster: @user3.id, productOwner: @user3.id)
    @projectSM = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user2.id)
  end

  describe "GET index" do
    it "lists projects with user as scrumMaster and as productOwner" do
      get :index
      assigns(:projectsAsScrumMaster).should include(@projectSM)
      assigns(:projectsAsProductOwner).should include(@projectPO)
    end

    context "when role==admin" do
      it "lists other projects in the system" do
        get :index
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :index
        assigns(:allProjects).should include(@projectOther)
      end
    end
  end


  describe "GET show" do
    context "when user is NOT an admin and proyect belongs to him" do
      it "assigns the requested project as @project" do
        get :show, {:id => @projectSM.to_param}
        assigns(:project).should eq(@projectSM)
      end
    end

    context "when user is NOT an admin and project does NOT belong to him" do
      it "redirects to projects path and notice" do
        get :show, {:id => @projectOther.to_param}
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is an admin" do
      it "shows the requested project" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :show, {:id => @projectSM.to_param}
        assigns(:project).should eq(@projectSM)
      end
    end
  end


  describe "GET new" do
    it "assigns a new project as @project" do
      get :new, {}
      assigns(:project).should be_a_new(Project)
    end
  end


  describe "GET edit" do
    context "when user is NOT an admin and the scrum master" do
      it "edits the requested project as @project" do
        get :edit, {:id => @projectSM.to_param}
        assigns(:project).should eq(@projectSM)
      end
    end

    context "when user is NOT an admin and the product owner" do
      it "edits the requested project as @project" do
        get :edit, {:id => @projectPO.to_param}
        assigns(:project).should eq(@projectPO)
      end
    end

    context "when user is NOT an admin and project does NOT belong to him" do
      it "does not allow to edit and notice" do
        get :edit, {:id => @projectOther.to_param}
        expect(response).to redirect_to(projects_path)
        flash[:notice].should_not be_nil
      end
    end

    context "when user is an admin" do
      it "edits the requested project" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        get :edit, {:id => @projectSM.to_param}
        assigns(:project).should eq(@projectSM)
      end
    end
  end


  describe "POST create" do
    context "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, {:project => @projectSM.attributes}
          }.to change(Project, :count).by(1)
      end
      it "assigns a newly created project as @project" do
        post :create, {:project => @projectSM.attributes}
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
      end
      it "redirects to the created project" do
        post :create, {:project => @projectSM.attributes}
        response.should redirect_to(Project.last)
      end
      it "should sent an email confirmation" do
        #ActionMailer::Base.deliveries.clear
        ActionMailer::Base.delivery_method = :test
        puts ActionMailer::Base.deliveries

        #Email sent to the Scrum Master
        @email_confirmation = ActionMailer::Base.deliveries.first
        @email_confirmation.from.should == ["kancrumer@gmail.com"]
        @email_confirmation.to.should == [@user.email]
        #Email sent to the Product Owner
        @email_confirmation = ActionMailer::Base.deliveries.last
        @email_confirmation.from.should == ["kancrumer@gmail.com"]
        @email_confirmation.to.should == [@user2.email]
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        Project.any_instance.stub(:save).and_return(false)
        post :create, {:project => { "name" => "invalid value" }}
        assigns(:project).should be_a_new(Project)
      end
      it "re-renders the 'new' template" do
        Project.any_instance.stub(:save).and_return(false)
        post :create, {:project => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end


  describe "PUT update" do
    context "with valid params" do
      it "updates the requested project" do
        Project.any_instance.should_receive(:update).with({ "name" => "MyString"})
        put :update, {:id => @projectSM.to_param, :project => { "name" => "MyString" }}
      end
      it "assigns the requested project as @project" do
        put :update, {:id => @projectSM.to_param, :project => @projectSM.attributes}
        assigns(:project).should eq(@projectSM)
      end
      it "redirects to the project" do
        put :update, {:id => @projectSM.to_param, :project => @projectSM.attributes}
        response.should redirect_to(@projectSM)
      end
    end

    context "with invalid params" do
      it "assigns the project as @project" do
        Project.any_instance.stub(:save).and_return(false)
        put :update, {:id => @projectSM.to_param, :project => { "name" => "invalid value" }}
        assigns(:project).should eq(@projectSM)
      end
      it "re-renders the 'edit' template" do
        Project.any_instance.stub(:save).and_return(false)
        put :update, {:id => @projectSM.to_param, :project => { "name" => "invalid value"}}
        response.should render_template("edit")
      end
    end
  end


  describe "DELETE destroy" do
    context "when user is scrum master he can deletes it" do
      it "destroys the requested project" do
        expect {    
          delete :destroy, {:id => @projectSM.to_param}
          }.to change(Project, :count).by(-1)
        end
      it "redirects to the projects list" do
        delete :destroy, {:id => @projectSM.to_param}
        response.should redirect_to(projects_url)
      end
    end

    context "when user is admin he can deletes it" do
      it "destroy the requested project and redirects to the project list" do
        admin = FactoryGirl.create(:administrador)
        login_user(admin)
        expect {
        delete :destroy, {:id => @projectPO.to_param}
        }.to change(Project, :count).by(-1)
        response.should redirect_to(projects_url)
      end
    end

    context "when user is NOT an admin NEITHER a scrum master" do
      it "does NOT destroy, redirects to the project path and notices" do
        delete :destroy, {:id => @projectPO.to_param}
        expect(response).to redirect_to projects_path
        flash[:notice].should_not be_nil
      end
    end
  end


  describe "changeOrder" do
    it "updates the order of the sprints that belongs to the project by following the order sent in the PUT request" do
      project = FactoryGirl.create(:project_with, scrumMaster: @user.id, productOwner: @user.id)
      sprint1 = FactoryGirl.create(:sprint1, order: 4, project: project)
      sprint2 = FactoryGirl.create(:sprint2, order: 94, project: project)
      put :changeOrder, {:id => project.id, :data =>  sprint1.id.to_s+";"+sprint2.id.to_s }
      Project.find(project).sprints.find(sprint1).order.should == 1
      Project.find(project).sprints.find(sprint2).order.should == 2
      response.should redirect_to(project)
    end
  end

end
