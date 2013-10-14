class AddRegistrationBooleanToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :registered, :boolean    
  end

  def self.down
    remove_column :users, :registered, :boolean    
  end
end
