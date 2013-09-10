json.array!(@text_messages) do |text_message|
  json.extract! text_message, 
  json.url text_message_url(text_message, format: :json)
end
