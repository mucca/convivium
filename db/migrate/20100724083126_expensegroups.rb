class Expensegroups < ActiveRecord::Migration
  def self.up  
    create_table "expensegroups_expenses", :id => false do |t|
      t.column "expensegroup_id", :integer, :null => false
      t.column "expense_id",  :integer, :null => false
    end                    
  end

  def self.down 
    drop_table "expensegroups_expenses" 
  end
end