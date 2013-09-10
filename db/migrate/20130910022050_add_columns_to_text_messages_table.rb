class AddColumnsToTextMessagesTable < ActiveRecord::Migration
  def self.up
    add_column :text_messages, :phone_number, :string
    add_column :text_messages, :text_body, :string
    add_column :text_messages, :send_time, :datetime    
  end

  def self.down
    remove_column :text_messages, :phone_number, :string
    remove_column :text_messages, :text_body, :string
    remove_column :text_messages, :send_time, :datetime    
  end
end
