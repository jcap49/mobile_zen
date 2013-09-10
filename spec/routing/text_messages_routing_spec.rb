require "spec_helper"

describe TextMessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/text_messages").should route_to("text_messages#index")
    end

    it "routes to #new" do
      get("/text_messages/new").should route_to("text_messages#new")
    end

    it "routes to #show" do
      get("/text_messages/1").should route_to("text_messages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/text_messages/1/edit").should route_to("text_messages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/text_messages").should route_to("text_messages#create")
    end

    it "routes to #update" do
      put("/text_messages/1").should route_to("text_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/text_messages/1").should route_to("text_messages#destroy", :id => "1")
    end

  end
end
