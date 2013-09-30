require 'iron_worker_ng'
require 'yaml'

# parse settings for iron_worker creds and instantiate client
config = YAML.load_file("application.yml")
project_id = config['IRONIO_PROJECT_ID']
token = config['IRONIO_TOKEN']
iron_worker = IronWorkerNG::Client.new(project_id: project_id, token: token)

TextMessages.each do |text_message|
  iron_worker.schedules.create("send_sms",
    text_message_id = text_message.id,
    {
      start_at: text_message.send_time.strftime("%I:%M%p") ,
      run_every: 3600 * 24
      })
end
