class AddScheduleIdToTextMessageTable < ActiveRecord::Migration
  def self.up
    add_column :text_messages, :schedule_id, :string    
  end

  def self.down
    remove_column :text_messages, :schedule_id, :string
  end
end
