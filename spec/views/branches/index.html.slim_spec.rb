require 'spec_helper'

describe "branches/index.html.slim" do
  before(:each) do
    assign(:branches, [
      stub_model(Branch,
        :project => nil,
        :name => "Name",
        :status => "Status"
      ),
      stub_model(Branch,
        :project => nil,
        :name => "Name",
        :status => "Status"
      )
    ])
  end

  it "renders a list of branches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
