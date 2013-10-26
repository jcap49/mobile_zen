FactoryGirl.define do 
  factory :text_message do 
    text_body "Shine on you crazy diamond"
    phone_number "315-749-8433"
    send_time DateTime.now
  end
end
