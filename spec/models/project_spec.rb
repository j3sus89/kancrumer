require_relative '../spec_helper'

describe Project do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:scrumMaster) }
  it { should validate_presence_of(:productOwner) }


  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user.id)
  end



  describe "darBienvenida" do
    it "sends an email to the new scrum members" do
      user2 = FactoryGirl.create(:usuario3)
      ActionMailer::Base.delivery_method = :test
      @project.users = [user2]
      @project.darBienvenida(user2)
      @email_confirmation = ActionMailer::Base.deliveries.last
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [user2.email]
    end 
  end 



  describe "causarBaja" do
    it "sends an email to the new scrum members" do
      user2 = FactoryGirl.create(:usuario3)
      ActionMailer::Base.delivery_method = :test
      @project.users = [user2]
      @project.causarBaja(user2)
      @email_confirmation = ActionMailer::Base.deliveries.last
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [user2.email]
    end 
  end 



  describe "getScrumMaster" do
  	it "returns an user whose id is scrumMaster" do
  		@project.getScrumMaster.should be_kind_of(User)
  	end
  end


  describe "getProductOwner" do
  	it "returns an user whose id is scrumMaster" do
  		@project.getProductOwner.should be_kind_of(User)
  	end
  end


  describe "scrumMember=(ids)" do
  	it "assigns the scrum member to the project" do
  		@project.scrumMember=(@user.email)
  		@project.users.should include(@user)
  	end
  end


  describe "getDevelopers" do
  	it "returns a list of users{email, name}" do
      user2 = FactoryGirl.create(:usuario3)
      @project.scrumMember=(user2.email)
      @project.getDevelopers.should == "[{\"email\":\"user@uesr.com\",\"name\":\"Jean Duser\"}]"
    end
  end


  describe "isScrumMaster?(person)" do
    context "when is scrum master" do
      it "returns true" do
        @project.isScrumMaster?(@user).should be_true
      end
    end

    context "when is NOT a scrum master" do
      it "returns false" do
        user2 = FactoryGirl.create(:usuario3)
        @project.isScrumMaster?(user2).should be_false
      end
    end
  end


  describe "isScrumMasterOrProductOwner?(person)" do
    context "when is scrum master" do
      it "returns true" do
        @project.isScrumMasterOrProductOwner?(@user).should be_true
      end
    end

    context "when is NOT a scrum master" do
      it "returns false" do
        user2 = FactoryGirl.create(:usuario3)
        @project.isScrumMasterOrProductOwner?(user2).should be_false
      end
    end

    context "when is product owner" do
      it "returns true" do
        @project.isScrumMasterOrProductOwner?(@user).should be_true
      end
    end

    context "when is NOT product owner" do
      it "returns false" do
        user2 = FactoryGirl.create(:usuario3)
        @project.isScrumMasterOrProductOwner?(user2).should be_false
      end
    end
  end


  describe "belongsToProject?(person)" do
    context "when it belongs to a project" do
      it "returns true" do
        @project.belongsToProject?(@user).should be_true
      end
    end

    context "when it does NOT belong to a project" do
      it "returns false" do
        user2 = FactoryGirl.create(:usuario3)
        @project.belongsToProject?(user2).should be_false
      end
    end
  end



  describe "sendEmailNewProject" do
    it "should send two emails" do
      @project.sendEmailNewProject
      ActionMailer::Base.delivery_method = :test
      @email_confirmation = ActionMailer::Base.deliveries.first
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [@user.email]
      @email_confirmation = ActionMailer::Base.deliveries.last
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [@user.email]
    end
  end


  describe "deleteFromComments(person)" do
    it "deletes the user from the comment as user" do
      sprint = FactoryGirl.create(:sprint1, project: @project)
      user_story = FactoryGirl.create(:userStory1, sprint: sprint)
      comment = FactoryGirl.create(:comment1, user: @user.id, user_story: user_story)
      comment.user.should_not be_nil
      @project.deleteFromComments(@user.id)
      comment.user.should be_nil
    end
  end


  describe "deleteFromUserStories(person)" do
    it "deletes the user from the user story responsibles" do
      us = FactoryGirl.create(:userStory1, sprint: FactoryGirl.create(:sprint1, project: @project))
      us.responsibles = [@user.email]
      us.responsibles.should_not be_empty
      @project.deleteFromUserStories(@user.id)
      us.responsibles.should be_empty
    end
  end


  describe "sendEmailIfChanges(previousSM, previousPO)" do
    it "sends emails alerting to the PO and SM, when they change" do
      user2 = FactoryGirl.create(:usuario2)
      @project.scrumMaster = user2.id
      @project.productOwner = user2.id
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.deliveries.clear
      @project.sendEmailIfChanges
      @email_confirmation = ActionMailer::Base.deliveries[0]
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [@user.email]
      @email_confirmation = ActionMailer::Base.deliveries[1]
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [user2.email]
      @email_confirmation = ActionMailer::Base.deliveries[2]
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [@user.email]
      @email_confirmation = ActionMailer::Base.deliveries[3]
      @email_confirmation.from.should == ["kancrumer@gmail.com"]
      @email_confirmation.to.should == [user2.email]
    end
  end

end
