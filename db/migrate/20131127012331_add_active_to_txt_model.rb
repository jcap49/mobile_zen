class AddActiveToTxtModel < ActiveRecord::Migration
  def self.up
    add_column :text_messages, :active, :boolean
  end

  def self.down
    remove_column :text_messages, :active, :boolean
  end
end
