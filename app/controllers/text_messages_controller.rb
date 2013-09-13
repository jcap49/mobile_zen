class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]
  # before_action :set_twilio_client, only: [:send_welcome_text_message]
  
  def index
    @text_messages = TextMessage.all
  end

  def show
  end

  def new
    @text_message = TextMessage.new
  end

  def edit
  end

  def create
    @text_message = TextMessage.new(text_message_params)

    #TODO: finish implementing create logic with proper error/notice handling
    if @text_message.save && TextMessage.find_by_phone_number(text_message_params[:phone_number]) == nil
      redirect_to root_path, notice: 'Text message was successfully created.' 
      send_welcome_text_message(text_message_params[:phone_number])
    elsif @text_message.save && TextMessage.find_by_phone_number(text_message_params[:phone_number]) != nil
      redirect_to root_path, notice: 'Text message was successfully created.'
      send_welcome_text_message(text_message_params[:phone_number])
      # redirect_to confirmation_path
    else
      render action: 'new', error: 'There was a problem with your submission. Please try again.'
    end
  end

  def update
    respond_to do |format|
      if @text_message.update(text_message_params)
        format.html { redirect_to @text_message, notice: 'Text message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @text_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @text_message.destroy
    respond_to do |format|
      format.html { redirect_to text_messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text_message
      @text_message = TextMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_message_params
      params.require(:text_message).permit(:phone_number, :text_body, :send_time)
    end

    def send_welcome_text_message(phone_number)
      set_twilio_client
      @client.account.sms.messages.create(
        from: TextMessage::TWILIO_PHONE_NUMBER,
        to: phone_number,
        body: "Hey there - welcome to Bonsai! Please reply with 'YES' to ensure your daily question is delivered on time."
        )
    end

    def set_twilio_client
      @client = Twilio::REST::Client.new(ENV["TEST_TWILIO_ACCOUNT_SID"], ENV["TEST_TWILIO_AUTH_TOKEN"])
    end
end
