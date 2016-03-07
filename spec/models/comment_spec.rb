require_relative '../spec_helper'

describe Comment do
  it { should validate_presence_of(:body) }

  before(:each) do
    @user = FactoryGirl.create(:usuario)
    @project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user.id)
    @user_story = FactoryGirl.create(:userStory1, sprint: FactoryGirl.create(:sprint1, project: @project))
  end

  describe "isAuthor?" do
  	context "when is author" do
  		it "returns true" do
  			comment = FactoryGirl.create(:comment1, user: @user.id, user_story: @user_story)
  			comment.isAuthor?(@user).should be_true
  		end
    end

    context "when is NOT the author" do
      it "returns false" do
        user2= FactoryGirl.create(:usuario3)
        comment = FactoryGirl.create(:comment1, user: user2.id, user_story: @user_story)
        comment.isAuthor?(@user).should be_false
      end
    end
  end


  describe "getUser" do
  	it "returns the comment's author" do
  		comment = FactoryGirl.create(:comment1, user: @user.id, user_story: @user_story)
      comment.getUser.should == @user
  	end
  end


  describe "setToNil" do
    it "sets the comment's user to nil" do
      comment = FactoryGirl.create(:comment1, user: @user.id, user_story: @user_story)
      comment.user.should_not be_nil
      comment.setUserToNil
      comment.user.should be_nil
    end
  end

end
