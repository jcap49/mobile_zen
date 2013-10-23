class CustomUsersController < Devise::RegistrationsController
  def new
    super
  end

  # extended devise reg controller (create action) to allow for submission 
  # of text message object then user registration
  def create
    build_resource(sign_up_params)

    if resource.save
      set_text_message
      update_text_message_user_id(@text_message)
      sanitize_phone_number(@text_message)
      send_welcome_text_message(@text_message.phone_number)
      execute_text_message_worker(@text_message.id, @text_message.send_time, @text_message.user_id)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      set_text_message
      @text_message.destroy
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

    def sign_up_params
      devise_parameter_sanitizer.sanitize(:sign_up)
    end

    def set_twilio_client
      @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end

    def set_text_message
      @text_message = TextMessage.find(session[:text_message_id])
    end

    # for unregistered users
    def send_welcome_text_message(phone_number)
      set_twilio_client
      @twilio_client.account.sms.messages.create(
        from: TextMessage::TWILIO_PHONE_NUMBER,
        to: phone_number,
        body: TextMessage::UNREGISTERED_WELCOME 
      )    
    end

    def execute_text_message_worker(text_message_id, send_time, user_id)
      iron_worker = IronWorkerNG::Client.new
      iron_worker.schedules.create("Master", { 
          :text_message_id => text_message_id,
          :user_id => user_id,
          :start_at => send_time,
          :run_every => 3600 * 24,
          :run_times => 365,
          :database => Rails.configuration.database_configuration[Rails.env]
        })
    end

    def update_text_message_user_id(text_message)
      text_message.user_id = resource.id
      text_message.save
    end

    def sanitize_phone_number(text_message)
      phone_number = text_message.phone_number
      phone_number.gsub!("-", "")
      phone_number.prepend("+1")
      text_message.update_column("phone_number", phone_number)
    end
end
  