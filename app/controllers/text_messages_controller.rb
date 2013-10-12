class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]
  # before_action :set_twilio_client, only: [:send_welcome_text_message]
  
  # def index
  #   @text_messages = TextMessage.all
  # end

  # def show
  # end

  def new
    @text_message = TextMessage.new
  end

  # def edit
  # end

  def create
    @text_message = TextMessage.new(text_message_params)

    #TODO: finish implementing create logic with proper error/notice handling
    if @text_message.save 
      redirect_to root_path, notice: 'Text message was successfully created.' 
      # send_welcome_text_message(text_message_params[:phone_number])
      execute_text_message_worker(@text_message.id, @text_message.send_time)
    else
      render action: 'new', error: 'There was a problem with your submission. Please try again.'
    end
  end

  # def update    
  #     if @text_message.update(text_message_params)
  #       redirect_to @text_message, notice: 'Text message was successfully updated.' 
  #     else
  #       render action: 'edit' 
  #     end
  #   end
  # end

  def destroy
    @text_message.destroy
    redirect_to root_path
  end

  def registration
    # 1. receive text message & instantiate TWiML (if necessary)
    # 2. extract text message number from header
    # 3. look up user with phone number & mark as registered
    # 4. save record
    # 5. send confirmation
    send_registration_confirmation(phone_number)
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
      # if TextMessage.find_by_phone_number(text_message_params[:phone_number]) == nil
        @twilio_client.account.sms.messages.create(
          from: TextMessage::TWILIO_PHONE_NUMBER,
          to: phone_number,
          body: TextMessage::REGISTERED_WELCOME_MESSAGE unless TextMessage.find_by_phone_number(text_message_params[:phone_number]) == nil TextMessage::UNREGISTERED_WELCOME_MESSAGE
          )
      # elsif TextMessage.find_by_phone_number(text_message_params[:phone_number]) != nil
      #   @twilio_client.account.sms.messages.create(
      #     from: TextMessage::TWILIO_PHONE_NUMBER,
      #     to: phone_number,
      #     body: TextMessage::REGISTERED_WELCOME_MESSAGE
      #     )
      # end
    end

    def send_registration_confirmation(phone_number)
      set_twilio_client
      @twilio_client.account.sms.messages.create(
          from: TextMessage::TWILIO_PHONE_NUMBER,
          to: phone_number,
          body: "Fantastic - you're all set to go. Thanks for registering!"
          )
    end

    def execute_text_message_worker(text_message_id, text_message_send_time)
      iron_worker = IronWorkerNG::Client.new
      iron_worker.schedules.create("Master",{ 
          :text_message_id => text_message_id,
          :start_at => text_message_send_time,
          :run_every => 3600 * 24,
          :database => Rails.configuration.database_configuration[Rails.env]
        })
    end

    def set_twilio_client
      @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end
end
