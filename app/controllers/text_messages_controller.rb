class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]

  # GET /text_messages
  # GET /text_messages.json
  def index
    @text_messages = TextMessage.all
  end

  # GET /text_messages/1
  # GET /text_messages/1.json
  def show
  end

  # GET /text_messages/new
  def new
    @text_message = TextMessage.new
  end

  # GET /text_messages/1/edit
  def edit
  end

  # POST /text_messages
  # POST /text_messages.json
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

  # PATCH/PUT /text_messages/1
  # PATCH/PUT /text_messages/1.json
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

  # DELETE /text_messages/1
  # DELETE /text_messages/1.json
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
      params[:text_message]
    end
end
