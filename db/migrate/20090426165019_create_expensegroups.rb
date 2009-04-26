class CreateExpensegroups < ActiveRecord::Migration
  def self.up
    create_table :expensegroups do |t|
      t.string :name

      t.timestamps
    end
    
    create_table :expensegroups_users do |t|
      t.references :expensegroup
      t.references :user
      t.timestamps
    end
    
  end

  def self.down
    drop_table :expensegroups
    drop_table :expensegroups_users
  end
end
