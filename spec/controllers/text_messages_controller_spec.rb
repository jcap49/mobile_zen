require 'spec_helper'

describe TextMessagesController do
  include SmsSpec::Helpers 

  before do 
    clear_messages
  end

  let!(:text_message)           { create(:text_message) } 
  let!(:text_message_with_user) { create(:text_message_with_user) }   
  let!(:user)                   { create(:user) }

  default_params = {
    text_body: "Shine on you crazy diamond",
    phone_number: "315-749-2232",
    send_time: DateTime.now
  }

  def create_text_message
    post :create, text_message: default_params 
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    @signed_in_user = user
  end


  describe "new" do
    it "should create an instance of text message with proper id" do
      # text_message_id is set as -1 to allow for 
      # proper association with a new user
      get :new, text_message_id: -1
      assigns(:text_message).should be_a_new(TextMessage)
    end
  end

  describe "create" do
    describe "without a signed in user" do 
      it "should create a text message if proper params passed" do
        pre_create_count = TextMessage.count
        post :create, text_message: default_params
        TextMessage.count.should == pre_create_count + 1

        open_last_text_message_for("#{text_message.phone_number}")
        current_text_message.should have_body "Hey there - welcome to Bonsai! Please reply with 'YES' to ensure your daily question is delivered on time."
      end

      it "should properly sanitize the given phone number" do 
      end

      it "should not create an experiment if improper params passed" do
        pre_create_count = TextMessage.count
        post :create, text_message: {text_body: nil, phone_number: "315-749-8433", send_time: DateTime.now}
        TextMessage.count.should == pre_create_count
      end 
    end

    describe "with a signed in user" do 
      # this isn't saving text message and is rendering 'new' action
      it "creates a text message if one associated with the user isn't found" do 
        login_user
        pre_create_count = TextMessage.count
        post :create, text_message: default_params
        TextMessage.count.should == pre_create_count + 1
        t = TextMessage.find_by_id(text_message.id)
        t.user_id.should == @signed_in_user.id

        open_last_text_message_for("#{text_message.phone_number}")
        current_text_message.should have_body "Hey there - welcome back to Bonsai! You're already opted into receiving your daily questions. Happy reflection!"
      end

      it "doesn't create a text message if one associated with the user is found" do 
        login_user 
        create_text_message
        pre_create_count = TextMessage.count
        post :create, text_message: default_params
        TextMessage.count.should == pre_create_count
      end
    end
  end

  # this describe block handles deletion of text message,
  # user registration and in the future response
  # categorization; in other words any subsequent method
  # called via parse_text_message_body
  describe "parse_text_message body" do 
    let(:twilio_phone_number) {"+13152353586"}

    describe "user responds with 'yes' to confirm registration" do
      before do 
        post :process_text_message, twiml_message(text_message_with_user.phone_number, "Yes", "To" => twilio_phone_number)
      end

      it "updates registration if the body of twilio POST request is 'yes'" do 
        confirmed_registration = User.find_by_id(user.id)
        confirmed_registration.registered?.should be_true
      end

      it "sends a text message with registration confirmation message" do 
        open_last_text_message_for("#{text_message_with_user.phone_number}")
        current_text_message.should have_body "Fantastic - you're all set to go. Text 'DELETE' to unsubscribe and delete your account."
      end
    end

    describe "user responds with 'delete' to delete account" do 
      before do 
        post :process_text_message, twiml_message(text_message.phone_number, "Delete", "To" => twilio_phone_number)
      end

      it "destroys a text message associated with user if the body of twilio POST request is 'delete'" do
        pre_destroy_count = TextMessage.count
        delete :destroy, id: text_message.id
        TextMessage.count = pre_destroy_count - 1
      end

      it "should send the user a final text with delete confirmation" do 
        open_last_text_message_for("#{text_message.phone_number}")
        current_text_message.should have_body "You've been successfully unsubscribed and your account has been deleted. Sorry to see you go!"
      end
    end
  end
end

