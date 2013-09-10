class CreateTextMessages < ActiveRecord::Migration
  def change
    create_table :text_messages do |t|

      t.timestamps
    end
  end
end
