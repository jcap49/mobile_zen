require 'spec_helper'

describe TextMessage do
  before(:each) do
    params = @params = {}
    params[:text_body] = "Shine on you crazy diamond"
    params[:send_time] = DateTime.now 
  end

  it "should pass validation with a proper length text body" do 
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_true
    expect(text_message.errors.count).to be(0)
  end


  it "should fail validation with an improper length text body" do 
    @params[:text_body] = ""
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_false
    expect(text_message.errors.count).to be(1)
  end

  it "should pass validation with proper send_time" do 
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_true
    expect(text_message.errors.count).to be(0)
  end

  it "should fail validation with improper send_time" do 
    @params[:send_time] = "jakdlf"
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_false
    expect(text_message.errors.count).to be(1)
  end

  it "should pass validation with a valid phone number via regex" do 
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_true
    expect(text_message.errors.count).to be(0)
  end

  it "should fail validation with an invalid phone number via regex" do 
    @params[:phone_number] = "bellend"
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_false
    expect(text_message.errors.count).to be(1)
  end

  it "should fail validation if no phone number present" do 
    @params[:phone_number] = nil
    text_message = TextMessage.new(@params)

    expect(text_message.valid?).to be_false
    expect(text_message.errors.count).to be(1)
  end

  # it "should fail validation if phone number isn't unique" do 
    
  #   text_message = TextMessage.new(@params)

  #   expect(text_message.valid?).to be_true
  #   expect(text_message.errors.count).to be(0)
  # end


end
