class TextMessagesController < ApplicationController

  def index
  end

  def new
    @text_message = TextMessage.new(params[:text_message])
    if user_signed_in?
      @saved_text_message = TextMessage.find_by_user_id(current_user.id)
    end
  end

  def create  
    @text_message = TextMessage.new(text_message_params)
    @text_message.user_id = -1
    
    unless @text_message.send_time.nil?
      sanitize_send_time(@text_message)
    end
    
    if user_signed_in? && @text_message.save
      @text_message.user_id = current_user.id
      @text_message.save
      sanitize_phone_number(@text_message)
      send_registered_welcome_text_message(@text_message.phone_number)
      TextMessage.execute_text_message_worker(@text_message.id, @text_message.send_time, @text_message.user_id)
      redirect_to root_path, notice: "Great - you're all sorted."
    elsif @text_message.save 
      session[:text_message_id] = @text_message.id
      redirect_to new_user_registration_path, notice: "Great - you'll just have to register for an account quickly."
    else
      render action: 'new', notice: "Whoops something went wrong - give it another go."
    end
  end 

  def process_text_message
    parse_text_message_body(params[:Body], params[:From])
  end

  private
    def set_text_message_via_twilio(phone_number)
      @text_message = TextMessage.find_by_phone_number(phone_number)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def text_message_params
      params.require(:text_message).permit(:phone_number, :text_body, :send_time, :user_id)
    end

    def set_twilio_client
      @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end

    def parse_text_message_body(text_message_body, phone_number)
      if text_message_body.downcase == 'yes' 
        User.update_registration(phone_number)
        render 'update_registration.xml.erb', content_type: 'text/xml'
      elsif text_message_body.downcase == 'delete'
        TextMessage.destroy(phone_number)
        send_account_deletion_message(phone_number)
      end   
    end

    # for previously registered users
    def send_registered_welcome_text_message(phone_number)
      set_twilio_client
      @twilio_client.account.sms.messages.create(
        from: TextMessage::TWILIO_PHONE_NUMBER,
        to: phone_number,
        body: TextMessage::REGISTERED_WELCOME 
        )    
    end

    def send_account_deletion_message(phone_number)
      set_twilio_client
      @twilio_client.account.sms.messages.create(
        from: TextMessage::TWILIO_PHONE_NUMBER,
        to: phone_number,
        body: TextMessage::REGISTERED_WELCOME 
        )
    end

    def sanitize_send_time(text_message)
      send_time = text_message.send_time
      if send_time < DateTime.now
        text_message.send_time = send_time + 1.day
      end
      send_time.utc
    end

    def sanitize_phone_number(text_message)
      phone_number = text_message.phone_number
      phone_number.gsub!("-", "")
      phone_number.prepend("+1")
      text_message.update_column("phone_number", phone_number)
    end
end