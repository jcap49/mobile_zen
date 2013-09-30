require 'twilio-ruby'
require 'yaml'

# parse the settings file for twilio creds
config = YAML.load_file("application.yml")
account_sid = config['TWILIO_ACCOUNT_SID']
auth_token = config['TWILIO_AUTH_TOKEN']
project_id = config['IRONIO_PROJECT_ID']
token = config['IRONIO_TOKEN']

# instantiate twilio client
twilio_client = Twilio::REST::Client.new(account_sid, auth_token)

# instantiate iron.io client
iron_client = IronCache::Client.new(project_id: project_id, token: token)

# send sms
twilio_client.account.sms.messages.create(
  from: TextMessages::TWILIO_PHONE_NUMBER,
  to: phone_number,
  body: sms_body
  )