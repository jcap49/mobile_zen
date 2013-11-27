class AddActiveColumnToTextMessage < ActiveRecord::Migration
  def self.up
    add_column :text_messages, :active, :string
  end

  def self.down
    remove_column :text_messages, :active, :string
  end
end
