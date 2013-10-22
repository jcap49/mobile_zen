class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]
  # before_action :set_twilio_client, only: [:send_welcome_text_message]
  
  # def index
  #   @text_messages = TextMessage.all
  # end

  # def show
  # end

  # def edit
  # end



  def create  
    @text_message = TextMessage.new(text_message_params)
    @text_message.user_id = -1

    # write method to check if user already has a text 
    # message created; if so return error

    if @text_message.save
      session[:text_message_id] = @text_message.id
      redirect_to new_user_registration_path
      # send_welcome_text_message(text_message_params[:phone_number])
      # execute_text_message_worker(@text_message.id, @text_message.send_time)
    else
      redirect_to root_path, notice: "Whoops something went wrong - give it another go."
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

  def destroy(phone_number)
    text_message = TextMessage.find_by_phone_number(phone_number)
    user_id = text_message.user_id
    user = User.find_by_id(user_id)
    text_message.destroy
    redirect_to root_path
  end

  def process_text_message
    parse_text_message_body(params[:Body], params[:From])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text_message
      @text_message = TextMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_message_params
      params.require(:text_message).permit(:phone_number, :text_body, :send_time, :user_id)
    end

    def set_twilio_client
      @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end

    # commented these two methods out as they've been
    # moved to the custom_users controller;
    # will delete once i've sorted out the refactoring
    # completely

    # def send_welcome_text_message(phone_number)
    #   set_twilio_client
    #   if TextMessage.find_by_phone_number(phone_number) == nil
    #     @twilio_client.account.sms.messages.create(
    #       from: TextMessage::TWILIO_PHONE_NUMBER,
    #       to: phone_number,
    #       body: TextMessage::UNREGISTERED_WELCOME 
    #       )
    #   elsif TextMessage.find_by_phone_number(phone_number) != nil
    #     @twilio_client.account.sms.messages.create(
    #       from: TextMessage::TWILIO_PHONE_NUMBER,
    #       to: phone_number,
    #       body: TextMessage::REGISTERED_WELCOME
    #       )
    #   end
    # end

    # def execute_text_message_worker(text_message_id, send_time)
    #   iron_worker = IronWorkerNG::Client.new
    #   iron_worker.schedules.create("Master", { 
    #       :text_message_id => text_message_id,
    #       :start_at => send_time,
    #       :run_every => 3600 * 24,
    #       :run_times => 365,
    #       :database => Rails.configuration.database_configuration[Rails.env]
    #     })
    # end

    def update_registration(phone_number)
      text_message = TextMessage.find_by_phone_number(phone_number)
      user_id = text_message.user_id
      user = User.find_by_id(user_id)
      user.update_attribute("registered", true)
      user.save!
    end

    def parse_text_message_body(text_message_body, phone_number)
      if text_message_body.downcase == 'yes' 
        update_registration(phone_number)
        render 'update_registration.xml.erb', content_type: 'text/xml'
      elsif text_message_body.downcase == 'stop'
        destroy(phone_number)
        render 'unsubscribe.xml.erb', content_type: 'text/xml'
      end   
    end
end
