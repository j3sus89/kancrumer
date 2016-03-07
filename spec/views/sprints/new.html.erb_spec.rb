require 'spec_helper'

describe "sprints/new" do
  before(:each) do
    assign(:sprint, stub_model(Sprint,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new sprint form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sprints_path, "post" do
      assert_select "input#sprint_name[name=?]", "sprint[name]"
      assert_select "input#sprint_description[name=?]", "sprint[description]"
    end
  end
end
