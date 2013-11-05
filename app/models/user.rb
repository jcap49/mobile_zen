class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: true
  
  has_many :text_messages
  accepts_nested_attributes_for :text_messages

  # checks to see if user has an active text message
  # current limit per user = 1
  def max_text_message_limit?(user_id)       
    text_messages = TextMessage.where(user_id: user_id)
    unless text_messages.count < 1
      true
    end
  end

  def self.update_registration(phone_number)
    text_message = TextMessage.find_by_phone_number(phone_number)
    user_id = text_message.user_id
    user = User.find_by_id(user_id)
    user.update_attribute("registered", true)
    user.save!
    TextMessage.execute_text_message_worker(text_message.id, text_message.send_time, text_message.user_id)
  end

  def self.cancel_account(user_id)
    user = User.find_by_user_id(user_id)
    user.destroy
  end
end

