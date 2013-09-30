require 'active_record'
require 'iron_worker_ng'
require 'pg'
require 'yaml'
require 'pry-rails'
# require '..models/text_message.rb'

# parse settings for iron_worker creds and instantiate client
config = YAML.load_file("../config/application.yml")
project_id = config['IRONIO_PROJECT_ID']
token = config['IRONIO_TOKEN']
iron_worker = IronWorkerNG::Client.new(project_id: project_id, token: token)

# parse settings for db creds
db_config = YAML.load_file("../config/database.yml")

def setup_database
  puts "Database connection details:#{params['database'].inspect}"
  return unless params['database']
  # estabilsh database connection
  ActiveRecord::Base.establish_connection(params['database'])
end

def queue_text_message
  iron_worker.schedules.create("send_sms",
    {
      :text_message_id => params['text_message_id'],
      :start_at => text_message.send_time.strftime("%I:%M%p"),
      :run_every => 3600 * 24
    })
end

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

setup_database
queue_text_message
# schedule_bulk_sms
