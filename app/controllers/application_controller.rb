class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def max_text_message_limit?       
    text_messages = TextMessage.find_by_user_id(current_user.id).all
    unless text_messages.count > 1
      true
    end
  end
end
