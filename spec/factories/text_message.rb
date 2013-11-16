FactoryGirl.define do 
  factory :text_message do 
    text_body "Shine on you crazy diamond"
    phone_number "315-749-8433"
    send_time DateTime.now
  
    factory :text_message_with_user do
      phone_number "315-740-9898" 
      user_id 1
    end
  end
end
