require 'spec_helper'

describe TextMessagesController do

  # This should return the minimal set of attributes required to create a valid
  # TextMessage. As you add validations to TextMessage, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TextMessagesController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "GET new" do
    it "assigns a new text_message as @text_message" do
      get :new, {}, valid_session
      assigns(:text_message).should be_a_new(TextMessage)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TextMessage" do
        expect {
          post :create, {:text_message => valid_attributes}, valid_session
        }.to change(TextMessage, :count).by(1)
      end

      it "assigns a newly created text_message as @text_message" do
        post :create, {:text_message => valid_attributes}, valid_session
        assigns(:text_message).should be_a(TextMessage)
        assigns(:text_message).should be_persisted
      end

      it "redirects to the created text_message" do
        post :create, {:text_message => valid_attributes}, valid_session
        response.should redirect_to(TextMessage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved text_message as @text_message" do
        # Trigger the behavior that occurs when invalid params are submitted
        TextMessage.any_instance.stub(:save).and_return(false)
        post :create, {:text_message => {  }}, valid_session
        assigns(:text_message).should be_a_new(TextMessage)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TextMessage.any_instance.stub(:save).and_return(false)
        post :create, {:text_message => {  }}, valid_session
        response.should render_template("new")
      end
    end

    describe "with a signed in user" do 
      it "creates a text message if one associated with the user isn't found" do 
      end

      it "doesn't create a text message if one associated with the user is found" do 
      end
    end

  end

  # need to figure out how to replicate twilio api calls? 
  # maybe consider using VCR
  describe "DELETE destroy" do
    it "destroys the requested text_message" do
      text_message = TextMessage.create! valid_attributes
      expect {
        delete :destroy, {:id => text_message.to_param}, valid_session
      }.to change(TextMessage, :count).by(-1)
    end

    it "redirects to the text_messages list" do
      text_message = TextMessage.create! valid_attributes
      delete :destroy, {:id => text_message.to_param}, valid_session
      response.should redirect_to(text_messages_url)
    end
  end

  describe "process_text_message handling" do 
    it "receives an incoming twilio POST request and passes to 'parse' method" do 
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
