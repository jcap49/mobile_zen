require 'spec_helper'

describe "text_messages/show" do
  before(:each) do
    @text_message = assign(:text_message, stub_model(TextMessage))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
