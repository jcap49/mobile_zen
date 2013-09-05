class CreateSmsTable < ActiveRecord::Migration
  def change
    create_table :sms_tables do |t|
      t.string :body
      t.string :phone_number
      t.datetime :date

      t.timestamps
    end
  end
end
