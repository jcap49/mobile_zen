class TextMessagesController < ApplicationController
  # before_action :set_text_message, only: [:index, :show, :update, :destroy]

  def index
  end

  def new
    @text_message = TextMessage.new(params[:text_message])
  end

  def create  
    @text_message = TextMessage.new(text_message_params)
    @text_message.user_id = -1

    if user_signed_in? && @text_message.save
      @text_message.user_id = current_user.id
      @text_message.save
      send_registered_welcome_text_message(@text_message.phone_number)
      redirect_to root_path, notice: "Text message successfully created."
    elsif @text_message.save 
      session[:text_message_id] = @text_message.id
      redirect_to new_user_registration_path
    else
      redirect_to root_path, notice: "Whoops something went wrong - give it another go."
    end
  end 

  # finish implementing method

  # def edit(phone_number, body)
  #   set_text_message_via_twilio(phone_number)
  #   @text_message.update_attribute(body: body)
  # end

  def destroy(phone_number)
    set_text_message_via_twilio(phone_number)
    @text_message.destroy
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
        update_registration(phone_number)
        render 'update_registration.xml.erb', content_type: 'text/xml'
      elsif text_message_body.downcase == 'delete'
        destroy(phone_number)
        render 'unsubscribe.xml.erb', content_type: 'text/xml'
      end   
    end

    def update_registration(phone_number)
      text_message = TextMessage.find_by_phone_number(phone_number)
      user_id = text_message.user_id
      user = User.find_by_id(user_id)
      user.update_attribute("registered", true)
      user.save!
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
end
