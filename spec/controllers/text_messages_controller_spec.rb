require 'spec_helper'

describe TextMessagesController do

  let!(:text_message) { create(:text_message) }  

  default_params = {
    text_body: "Shine on you crazy diamond",
    phone_number: "315-749-8432",
    send_time: DateTime.now
  }

  def create_text_message
    post :create, text_message: default_params 
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    sign_in @user
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
      end

      it "should not create an experiment if improper params passed" do
        pre_create_count = TextMessage.count
        post :create, text_message: {text_body: nil, phone_number: "315-749-8433", send_time: DateTime.now}
        TextMessage.count.should == pre_create_count
      end 
    end

    describe "with a signed in user" do 
      it "creates a text message if one associated with the user isn't found" do 
        login_user
        pre_create_count = TextMessage.count
        post :create, text_message: default_params
        TextMessage.count.should == pre_create_count + 1
        t = TextMessage.find_by_id(text_message.id)
        t.user_id.should == @user.id
      end

      it "doesn't create a text message if one associated with the user is found" do 
        login_user 
        create_text_message
        pre_create_count = TextMessage.count
        binding.pry
        post :create, text_message: default_params
        TextMessage.count.should == pre_create_count
      end
    end
  end

  # need to figure out how to replicate twilio api calls? 
  # maybe consider using VCR
  describe "destroy" do
    it "destroys the requested text_message" do
      
    end
  end

  describe "parse_text_message body" do 
    it "updates registration if the body of twilio POST request is 'yes'" do 
    end

    it "destroys a text message associated with user if the body of twilio POST request is 'delete'" do
    end

    it "doesn't update registration or delete user info if body is malformed" do 
    end
  end
end

