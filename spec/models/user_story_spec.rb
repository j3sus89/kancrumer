require_relative '../spec_helper'

describe UserStory do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:code) }
  it { should validate_numericality_of(:state) }
  it { should validate_numericality_of(:effort) }
  it { should validate_numericality_of(:verticalOrder) }

  before(:each) do
  	@user = FactoryGirl.create(:usuario)
  	@project = FactoryGirl.create(:project_with, scrumMaster: @user.id, productOwner: @user.id, users: [@user])
    @us = FactoryGirl.create(:userStory1, sprint: FactoryGirl.create(:sprint1, project: @project))
  end

  describe "setNew" do
  	it "should initializes" do
  		@us.setNew
  		@us.responsibles.should be_empty
  	end
  end


  describe "us_resp=(ids)" do
  	it "assigns user as responsible" do
	  	@us.us_resp=(@user.email)
	  	@us.responsibles[0].should == @user.email
	  end 
  end


  describe "checkResponsibles" do
  	it "filters the users that doesn't belong to the project" do
  		user2 = FactoryGirl.create(:usuario3)
  		@us.us_resp = @user.email.to_s+","+user2.email.to_s
  		@us.responsibles[0].should == @user.email
  		@us.responsibles[1].should == user2.email
  		@us.checkResponsibles
  		@us.responsibles[0].should == @user.email
  		@us.responsibles[1].should be_nil
    end
  end


    describe "getDevelopers" do
    it "returns a list of users{email, name}" do
      user2 = FactoryGirl.create(:usuario3)
      @us.us_resp=(user2.email)
      @us.getResponsibles.should == "[{\"email\":\"user@uesr.com\",\"name\":\"Jean Duser\"}]"
    end
  end


end
