require 'spec_helper'

describe "user_stories/new" do
  before(:each) do
    assign(:user_story, stub_model(UserStory,
      :title => "",
      :description => "",
      :estado => ""
    ).as_new_record)
  end

  it "renders new user_story form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_stories_path, "post" do
      assert_select "input#user_story_title[name=?]", "user_story[title]"
      assert_select "input#user_story_description[name=?]", "user_story[description]"
      assert_select "input#user_story_estado[name=?]", "user_story[estado]"
    end
  end
end
