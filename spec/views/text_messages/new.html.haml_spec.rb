require 'spec_helper'

describe "text_messages/new" do
  before(:each) do
    assign(:text_message, stub_model(TextMessage).as_new_record)
  end

  it "renders new text_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", text_messages_path, "post" do
    end
  end
end
