class PagesController < ApplicationController

  def index
    @text_message = TextMessage.new(params[:text_message])
    @user = User.new(params[:user])
  end

  protected
    # def max_text_message_limit?       
    #   text_messages = TextMessage.find_by_user_id(current_user.id).all
    #   unless text_messages.count > 1
    #     true
    #   end
    # end
end
