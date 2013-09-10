class DropSmsTable < ActiveRecord::Migration
  def change
    drop_table :sms_tables
  end
end
