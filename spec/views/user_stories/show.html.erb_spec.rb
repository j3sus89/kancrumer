require 'spec_helper'

describe "user_stories/show" do
  before(:each) do
    @user_story = assign(:user_story, stub_model(UserStory,
      :title => "",
      :description => "",
      :estado => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
