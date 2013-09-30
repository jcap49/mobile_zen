require 'twilio-ruby'
require 'yaml'

# parse the settings file for twilio creds
config = YAML.load_file("application.yml")
account_sid = config['TWILIO_ACCOUNT_SID']
auth_token = config['TWILIO_AUTH_TOKEN']
project_id = config['IRONIO_PROJECT_ID']
token = config['IRONIO_TOKEN']
text_messages = TextMessage.all

# instantiate twilio client
twilio_client = Twilio::REST::Client.new(account_sid, auth_token)

# instantiate iron.io client
iron_client = IronCache::Client.new(project_id: project_id, token: token)

# send sms
text_messages.each do |text_message|  
  twilio_client.account.sms.messages.create(
    from: TextMessages::TWILIO_PHONE_NUMBER,
    to: text_message.phone_number,
    body: text_message.text_body
    )
end