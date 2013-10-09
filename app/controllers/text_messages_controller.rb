class TextMessagesController < ApplicationController
  before_action :set_text_message, only: [:show, :edit, :update, :destroy]
  # before_action :set_twilio_client, only: [:send_welcome_text_message]
  
  # def index
  #   @text_messages = TextMessage.all
  # end

  # def show
  # end

  def new
    @text_message = TextMessage.new
  end

  # def edit
  # end

  def create
    @text_message = TextMessage.new(text_message_params)

    #TODO: finish implementing create logic with proper error/notice handling
    if @text_message.save 
      redirect_to root_path, notice: 'Text message was successfully created.' 
      # send_welcome_text_message(text_message_params[:phone_number])
      execute_text_message_worker(@text_message.id, @text_message.send_time)
    else
      render action: 'new', error: 'There was a problem with your submission. Please try again.'
    end
  end

  # def update    
  #     if @text_message.update(text_message_params)
  #       redirect_to @text_message, notice: 'Text message was successfully updated.' 
  #     else
  #       render action: 'edit' 
  #     end
  #   end
  # end

  def destroy
    @text_message.destroy
    redirect_to root_path
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

    def send_welcome_text_message(phone_number)
      set_twilio_client
      if TextMessage.find_by_phone_number(text_message_params[:phone_number]) == nil
        @twilio_client.account.sms.messages.create(
          from: TextMessage::TWILIO_PHONE_NUMBER,
          to: phone_number,
          body: "Hey there - welcome to Bonsai! Please reply with 'YES' to ensure your daily question is delivered on time."
          )
      elsif TextMessage.find_by_phone_number(text_message_params[:phone_number]) != nil
        @twilio_client.account.sms.messages.create(
          from: TextMessage::TWILIO_PHONE_NUMBER,
          to: phone_number,
          body: "Hey there - welcome back to Bonsai! You're already opted into receiving your daily questions. Happy reflection!"
          )
      end
    end

    def execute_text_message_worker(text_message_id, text_message_send_time)
      iron_worker = IronWorkerNG::Client.new
      iron_worker.schedules.create("Master",{ 
          :text_message_id => text_message_id,
          :start_at => text_message_send_time,
          :run_every => 3600 * 24,
          :database => Rails.configuration.database_configuration[Rails.env]
        })
    end

    def set_twilio_client
      @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end

    def set_iron_client
<<<<<<< Updated upstream
<<<<<<< Updated upstream
      if Rails.env == 'production'
        @iron_worker = IronWorkerNG::Client.new
      elsif Rails.env == 'development'
        @iron_worker = IronWorkerNG::Client.new(project_id: ENV['IRON_WORKER_PROJECT_ID'], token: ENV['IRON_WORKER_TOKEN']) 
      end
=======
      @iron_client = IronWorkerNG::Client.new(project_id: ENV['IRON_WORKER_PROJECT_ID'], token: ENV['IRON_WORKER_TOKEN'])   
>>>>>>> Stashed changes
=======
      @iron_client = IronWorkerNG::Client.new(project_id: ENV['IRON_WORKER_PROJECT_ID'], token: ENV['IRON_WORKER_TOKEN'])   
>>>>>>> Stashed changes
    end
end
