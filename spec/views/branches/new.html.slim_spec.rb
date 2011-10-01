require 'spec_helper'

describe "branches/new.html.slim" do
  before(:each) do
    assign(:branch, stub_model(Branch,
      :project => nil,
      :name => "MyString",
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new branch form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => branches_path, :method => "post" do
      assert_select "input#branch_project", :name => "branch[project]"
      assert_select "input#branch_name", :name => "branch[name]"
      assert_select "input#branch_status", :name => "branch[status]"
    end
  end
end
