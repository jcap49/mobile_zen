require 'twilio-ruby'
require 'yaml'

# parse the settings file for twilio & iron_worker creds
config = YAML.load_file("application.yml")
account_sid = config['TWILIO_ACCOUNT_SID']
auth_token = config['TWILIO_AUTH_TOKEN']

text_message = TextMessage.find_by_id(params['text_message_id'])

# instantiate twilio client
twilio_client = Twilio::REST::Client.new(account_sid, auth_token)

# send sms
def send_sms
  twilio_client.account.sms.messages.create(
    from: TextMessages::TWILIO_PHONE_NUMBER,
    to: text_message.phone_number,
    body: text_message.text_body
  )  
end

send_sms

