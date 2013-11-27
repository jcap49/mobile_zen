class ChangeColumnTypeForActiveInTextMessage < ActiveRecord::Migration
  def self.up
    remove_column :text_messages, :active, :string
  end

  def self.down
    add_column :text_messages, :active, :string
  end
end
