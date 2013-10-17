class PagesController < ApplicationController

  def index
    @text_message = TextMessage.new(params[:text_message])
  end
end
