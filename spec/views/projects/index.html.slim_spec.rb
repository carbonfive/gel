require 'spec_helper'

describe "projects/index.html.slim" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name    => "Name1",
        :git_url => "Git Url1",
        :status  => "Status"
      ),
      stub_model(Project,
        :name    => "Name2",
        :git_url => "Git Url2",
        :status  => "Status"
      )
    ])
  end

  it "renders a list of projects" do
    render
  end
end
