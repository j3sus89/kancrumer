require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :scrumMaster => "",
      :productOwner => ""
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_path(@project), "post" do
      assert_select "input#project_name[name=?]", "project[name]"
      assert_select "input#project_scrumMaster[name=?]", "project[scrumMaster]"
      assert_select "input#project_productOwner[name=?]", "project[productOwner]"
    end
  end
end
