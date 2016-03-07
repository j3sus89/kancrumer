require 'spec_helper'

describe "user_stories/index" do
  before(:each) do
    assign(:user_stories, [
      stub_model(UserStory,
        :title => "",
        :description => "",
        :estado => ""
      ),
      stub_model(UserStory,
        :title => "",
        :description => "",
        :estado => ""
      )
    ])
  end

  it "renders a list of user_stories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
