class CreateExpensegroups < ActiveRecord::Migration
  def self.up
    create_table :expensegroups do |t|
      t.string :name
      t.references :personal
      t.boolean :disabled
      t.timestamps
    end
    
    create_table :expensegroups_users, :id => false do |t|
      t.references :expensegroup
      t.references :user
      t.timestamps
    end
    
    for user in User.all:
      Expensegroup.create( :name=>user.login + " personal expense", :users=>[ user ], :personal=>user )
    end
    Expensegroup.create( :name=>"shared", :users=>User.all )
    
  end

  def self.down
    drop_table :expensegroups
    drop_table :expensegroups_users
  end
end
