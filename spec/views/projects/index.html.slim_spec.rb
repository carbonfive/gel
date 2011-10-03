require 'spec_helper'

describe "projects/index.html.slim" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name => "Name",
        :git_url => "Git Url"
      ),
      stub_model(Project,
        :name => "Name",
        :git_url => "Git Url"
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Git Url".to_s, :count => 2
  end
end
