require 'spec_helper'

describe "text_messages/index" do
  before(:each) do
    assign(:text_messages, [
      stub_model(TextMessage),
      stub_model(TextMessage)
    ])
  end

  it "renders a list of text_messages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
