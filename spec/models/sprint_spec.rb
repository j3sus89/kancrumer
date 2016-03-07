require_relative '../spec_helper'

describe Sprint do
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:order) }
  it {should allow_value("23-03-2016").for(:deadline)}
  it {should_not allow_value("xx-xx-xxxx").for(:deadline)}
  it {should allow_value("23-03-2016").for(:startdate)}
  it {should_not allow_value("av-bc-defg").for(:startdate)}


  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @project = FactoryGirl.create(:project_with, scrumMaster: @user.id, productOwner: @user.id)
  end


  describe "setNew" do
  	it "should set the new attribute order" do
  		sprint = FactoryGirl.create(:sprint1, project: @project)
      sprint.setNew
  		sprint.order.should == 2
  	end
  end


  describe "changeOrder" do
  	it "should change the attribute order" do
	  	sprint = FactoryGirl.create(:sprint1, project: @project)
	  	sprint2 = FactoryGirl.create(:sprint2, project: @project)
	  	sprint.destroy
      sprint2.changeOrder
	  	sprint2.order.should == 1
  	end
  end


  describe "getCompleteness" do
    it "should return the % of completeness" do
      sprint = FactoryGirl.create(:sprint1, project: @project)
      us1 = FactoryGirl.create(:userStory1, sprint: sprint, state: 3)
      us2 = FactoryGirl.create(:userStory2, sprint: sprint, state: 1)
      sprint.getCompleteness.should == 50
    end
  end


end