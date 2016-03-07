require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "Name",
      :role => "Role",
      :email => "Email",
      :crypted_password => "Crypted Password",
      :salt => "Salt"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Role/)
    rendered.should match(/Email/)
    rendered.should match(/Crypted Password/)
    rendered.should match(/Salt/)
  end
end