class TextMessage < ActiveRecord::Base

  validates :text_body, length: {minimum: 2, maximum: 160, too_short: 'must be at least %{count} characters', too_long: 'cannot be more than %{count} characters.' }
  validates :send_time, presence: {message: 'must be present.'}
  validates :phone_number, format: {with: /^(1?)(-| ?)(\()?([0-9]{3})(\)|-| |\)-|\) )?([0-9]{3})(-| )?([0-9]{4}|[0-9]{4})$/, multiline: true}
  
  belongs_to :user


  # Twilio & SMS-related constants
  TWILIO_PHONE_NUMBER = '+13152353586'
  UNREGISTERED_WELCOME_MESSAGE = "Hey there - welcome to Bonsai! Please reply with 'YES' to ensure your daily question is delivered on time."
  REGISTERED_WELCOME_MESSAGE = "Hey there - welcome back to Bonsai! You're already opted into receiving your daily questions. Happy reflection!"
end
