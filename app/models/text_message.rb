class TextMessage < ActiveRecord::Base

  validates :text_body, length: {minimum: 2, maximum: 160, too_short: 'The message body must be at least %{count} characters', too_long: 'cannot be more than %{count} characters.' }
  validates :send_time, presence: {message: 'Send time must be present.'}
  validates :phone_number, format: {with: /^(1?)(-| ?)(\()?([0-9]{3})(\)|-| |\)-|\) )?([0-9]{3})(-| )?([0-9]{4}|[0-9]{4})$/, multiline: true, message: 'Phone number'}
  validates :phone_number, presence: {message: 'Phone number must be present.'}
  validates :phone_number, uniqueness: true 
  
  belongs_to :user

  # Twilio & SMS-related constants
  TWILIO_PHONE_NUMBER = '+13152353586'
  UNREGISTERED_WELCOME = "Hey there - welcome to Bonsai! Please reply with 'YES' to ensure your daily question is delivered on time."
  REGISTERED_WELCOME = "Hey there - welcome back to Bonsai! You're already opted into receiving your daily questions. Happy reflection!"

    def self.parse_text_message_body(text_message_body, phone_number)
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
      execute_text_message_worker(text_message.id, text_message.send_time, text_message.user_id)
    end

    # need to refactor to use iron_worker scheduler
    # once it is fixed; broken as of 10/26
    def execute_text_message_worker(text_message_id, send_time, user_id)
      iron_worker = IronWorkerNG::Client.new
      iron_worker.tasks.create("Master", { 
          :text_message_id => text_message_id,
          :user_id => user_id,
          :database => Rails.configuration.database_configuration[Rails.env],
        })
    end

    def destroy(phone_number)
      set_text_message_via_twilio(phone_number)
      @text_message.destroy
      redirect_to root_path
    end

    
    def set_text_message_via_twilio(phone_number)
      @text_message = TextMessage.find_by_phone_number(phone_number)
    end
end
