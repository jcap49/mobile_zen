class PagesController < ApplicationController

  def index
    @text_message = TextMessage.new(params[:text_message])
    @user = User.new(params[:user])
  end
end
