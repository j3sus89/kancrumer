require_relative "../spec_helper"



describe UserMailer do

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @user2 = FactoryGirl.create(:usuario2)
    @project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user2.id)
  end


  describe "activation_needed_email" do
    it "should be like this" do
      @mail = UserMailer.activation_needed_email(@user)
      @mail.subject.should eq("Welcome to Kancrumer")
      @mail.to.should eq([@user.email])
    end
  end


  describe "activation_success_email" do
    it "should be like this" do
      @mail = UserMailer.activation_success_email(@user)
      @mail.subject.should eq("Your account is now activated")
      @mail.to.should eq([@user.email])
    end
  end


  describe "reset_password_email" do
    it "should be like this" do
      @mail = UserMailer.reset_password_email(@user)
      @mail.subject.should eq("Your password has been reset")
      @mail.to.should eq([@user.email])
    end
  end


  describe "new_project" do
    it "should be like this" do
      @mail = UserMailer.new_project(@project)
      @mail.subject.should eq("New project")
      @mail.to.should eq([@user.email])
    end
  end

    describe "new_scrumMaster" do
    it "should be like this" do
      @mail = UserMailer.new_scrumMaster(@project)
      @mail.subject.should eq("New project as Scrum Master")
      @mail.to.should eq([@user.email])
    end
  end

    describe "reject_scrumMaster" do
    it "should be like this" do
      @mail = UserMailer.reject_scrumMaster(@user, @project)
      @mail.subject.should eq("Rejected as Scrum Master")
      @mail.to.should eq([@user.email])
    end
  end

  describe "new_productOwner" do
    it "should be like this" do
      @mail = UserMailer.new_productOwner(@project)
      @mail.subject.should eq("New project as Product Owner")
      @mail.to.should eq([@user2.email])
    end
  end


  describe "reject_productOwner" do
    it "should be like this" do
      @mail = UserMailer.reject_productOwner(@user2, @project)
      @mail.subject.should eq("Rejected as Product Owner")
      @mail.to.should eq([@user2.email])
    end
  end


  describe "new_scrumMember" do
    it "should be like this" do
      @mail = UserMailer.new_scrumMember(@user, @project)
      @mail.subject.should eq("New project as Scrum Member")
      @mail.to.should eq([@user.email])
    end
  end


  describe "reject_scrumMember" do
    it "should be like this" do
      @mail = UserMailer.reject_scrumMember(@user, @project)
      @mail.subject.should eq("Dismissed as Scrum Member")
      @mail.to.should eq([@user.email])
    end
  end

end
