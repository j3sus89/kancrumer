require_relative '../spec_helper'

describe User do
	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email)}
	it { should validate_presence_of(:password) }
	it { should ensure_length_of(:password).is_at_least(6) }
	it { should validate_confirmation_of(:password)}
	it { should validate_presence_of(:name) }


	before(:each) do
		@user = FactoryGirl.create(:usuario)
		@project = FactoryGirl.create(:project1, scrumMaster: @user.id, productOwner: @user.id)
	end



	describe "isAdmin" do
		context "when is an admin" do
			it "is returns true" do
				@user.should_not be_isAdmin
			end
		end

		context "when is not an admin" do
			it "is an admin" do
				admin = FactoryGirl.create(:administrador)
				admin.should be_isAdmin
			end
		end
	end



	describe "isScrumMasterOrProductOwner?" do
		context "when is an scrum master" do
			it "it returns true" do
				@user.should be_isScrumMasterOrProductOwner
			end
		end

		context "when is not an scrum master " do
			it "it returns false" do
				user2 = FactoryGirl.create(:usuario2)
				user2.should_not be_isScrumMasterOrProductOwner
			end
		end

		context "when is a product owner" do
			it "returns true" do
				@user.should be_isScrumMasterOrProductOwner
			end
		end

		context "when is not a product owner" do
			it "returns false" do
				user2 = FactoryGirl.create(:usuario2)
				user2.should_not be_isScrumMasterOrProductOwner
			end
		end
	end



	describe "deleteUserFromUserStories" do
		it "deletes the user from the user story responsibles" do
			@user.projects = [@project]
			user_story = FactoryGirl.create(:userStory1, sprint: FactoryGirl.create(:sprint1, project: @project))
			user_story.responsibles = [@user.email]
			user_story.responsibles.should_not be_empty
			@user.deleteUserFromUserStories
			user_story.responsibles.should be_empty
		end 
	end 



	describe "deleteUserFromComments" do
		it "deletes the comment's author" do
			@user.projects = [@project]
			user_story = FactoryGirl.create(:userStory1, sprint: FactoryGirl.create(:sprint1, project: @project))
			comment = FactoryGirl.create(:comment1, user: @user.id, user_story: user_story)
			comment.user.should_not be_nil
			@user.deleteUserFromComments
			comment.user.should be_nil
		end 
	end 
end
