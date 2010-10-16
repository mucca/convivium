class AddPersonalTransaction < ActiveRecord::Migration
  def self.up
    add_column :expenses, :personal_transaction, :boolean, :default => false
  end

  def self.down
    remove_column :expenses, :personal_transaction
  end
end
