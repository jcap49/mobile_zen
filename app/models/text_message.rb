class TextMessage < ActiveRecord::Base

  validates :text_body, length: {minimum: 2, maximum: 160, too_short: 'The message body must be at least %{count} characters', too_long: 'cannot be more than %{count} characters.' }
  validates :send_time, presence: {message: 'Send time must be present.'}
  validates :phone_number, format: {with: /^(1?)(-| ?)(\()?([0-9]{3})(\)|-| |\)-|\) )?([0-9]{3})(-| )?([0-9]{4}|[0-9]{4})$/, multiline: true, message: "Phone number must be in format: 'xxx-xxx-xxxx' "}
  validates :phone_number, presence: {message: 'Phone number must be present.'}
  validates :phone_number, uniqueness: true 
  
  belongs_to :user

  # Twilio & SMS-related constants
  TWILIO_PHONE_NUMBER = '+13152353586'
  UNREGISTERED_WELCOME = "Hey there - welcome to Bonsai! Please reply with 'YES' to ensure your daily question is delivered on time."
  REGISTERED_WELCOME = "Hey there - welcome back to Bonsai! You're already opted into receiving your daily questions. Happy reflection!"

    # need to refactor to use iron_worker scheduler
    # once it is fixed; broken as of 10/26
    def self.execute_text_message_worker(text_message_id, send_time, user_id)
      iron_worker = IronWorkerNG::Client.new
      iron_worker.schedules.create("Master", { 
          :text_message_id => text_message_id,
          :user_id => user_id,
          :start_at => send_time,
          :run_every => 3600 * 24,
          :run_times => 365,
          :database => Rails.configuration.database_configuration[Rails.env],
        })
    end
end
