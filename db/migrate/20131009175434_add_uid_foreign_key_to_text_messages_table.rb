class AddUidForeignKeyToTextMessagesTable < ActiveRecord::Migration
  def self.up
    add_column :text_messages, :user_id, :integer   
  end

  def self.down
    remove_column :text_messagse, :user_id, :integer    
  end
end
