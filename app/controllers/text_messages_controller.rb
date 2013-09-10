class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]

  
  def index
    @text_messages = TextMessage.all
  end

  def show
  end

  def new
    @text_message = TextMessage.new
  end

  def edit
  end

  def create
    @text_message = TextMessage.new(text_message_params)

    respond_to do |format|
      if @text_message.save
        format.html { redirect_to @text_message, notice: 'Text message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @text_message }
      else
        format.html { render action: 'new' }
        format.json { render json: @text_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @text_message.update(text_message_params)
        format.html { redirect_to @text_message, notice: 'Text message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @text_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @text_message.destroy
    respond_to do |format|
      format.html { redirect_to text_messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text_message
      @text_message = TextMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_message_params
      params.require(:text_message).permit(:phone_number, :text_body, :send_time)
    end
end
