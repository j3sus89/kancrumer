require 'spec_helper'

describe "sprints/index" do
  before(:each) do
    assign(:sprints, [
      stub_model(Sprint,
        :name => "Name",
        :description => "Description"
      ),
      stub_model(Sprint,
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of sprints" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
