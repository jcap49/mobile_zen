require 'active_record'
require 'iron_worker_ng'
require 'twilio-ruby'
require 'pg'
require 'yaml'
require 'models/text_message'

# load in twilio vars
config = YAML.load_file("application.yml")
@account_sid = config['TWILIO_ACCOUNT_SID']
@auth_token = config['TWILIO_AUTH_TOKEN']


def setup_database
  puts "Database connection details: #{params['database'].inspect}"
  return unless params['database']
  # estabilsh database connection
  ActiveRecord::Base.establish_connection(params['database'])
end

def send_sms
  twilio_client = Twilio::REST::Client.new(@account_sid, @auth_token)
  text_message = TextMessage.find_by_id(params['text_message_id'])
  twilio_client.account.sms.messages.create(
    from: TextMessage::TWILIO_PHONE_NUMBER,
    to: text_message.phone_number,
    body: text_message.text_body
  )  
end

setup_database
send_sms

# def queue_text_message
#   text_message = TextMessage.find_by_id(params['text_message_id'])
#   iron_worker.schedules.create("SendSMS",
#     { :text_message_id => params['text_message_id'],
#       :start_at => text_message.send_time.strftime("%I:%M%p"),
#       :run_every => 3600 * 24
#     })
# end

# for bulk sending
# def schedule_bulk_sms
#   TextMessage.each do |text_message|
#   iron_worker.schedules.create("send_sms",
#     {
#       :database => Rails.configuration.database_configuration[Rails.env],
#       :text_message_id => text_message.id,
#       :start_at => text_message.send_time.strftime("%I:%M%p"),
#       :run_every => 3600 * 24
#       })
#   end
# end

# queue_text_message
# schedule_bulk_sms
