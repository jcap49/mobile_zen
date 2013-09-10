require 'spec_helper'

describe "text_messages/edit" do
  before(:each) do
    @text_message = assign(:text_message, stub_model(TextMessage))
  end

  it "renders the edit text_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", text_message_path(@text_message), "post" do
    end
  end
end
