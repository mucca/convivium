class LastLoginForUser < ActiveRecord::Migration
  def self.up
      add_column :users, :last_login, :datetime
      add_column :users, :previous_login, :datetime
  end

  def self.down
      remove_column :users, :last_login
      remove_column :users, :previous_login
  end
end
