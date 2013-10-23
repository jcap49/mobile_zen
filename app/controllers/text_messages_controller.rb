class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]

  def create  
    if user_signed_in?
      unless TextMessage.find_by_user_id(current_user.id) != nil
        @text_message = TextMessage.new(text_message_params)
        @text_message.user_id = current_user.id

        if @text_message.save
          send_welcome_text_message(@text_message.phone_number)
          redirect_to root_path, notice: "Text message successfully created." and return
        else
          redirect_to root_path, notice: "Whoops something went wrong - give it another go." and return
        end
      end
      redirect_to root_path, notice: "Sorry - only one text message per person. For now. :)"
    end

    @text_message = TextMessage.new(text_message_params)
    @text_message.user_id = -1

    if @text_message.save
      session[:text_message_id] = @text_message.id
      redirect_to new_user_registration_path
    else
      redirect_to root_path, notice: "Whoops something went wrong - give it another go."
    end
  end 

  def destroy(phone_number)
    text_message = TextMessage.find_by_phone_number(phone_number)
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
    def send_welcome_text_message(phone_number)
      set_twilio_client
      @twilio_client.account.sms.messages.create(
        from: TextMessage::TWILIO_PHONE_NUMBER,
        to: phone_number,
        body: TextMessage::REGISTERED_WELCOME 
        )    
    end
end
