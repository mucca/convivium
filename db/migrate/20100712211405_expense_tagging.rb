class ExpenseTagging < ActiveRecord::Migration
  def self.up
    create_table "expenses_users", :id => false do |t|
      t.column "expense_id", :integer, :null => false
      t.column "user_id",  :integer, :null => false
    end
    for expense in Expense.all
      expense.users = expense.expensegroup.users
      expense.save!
    end
    for g in Expensegroups.all
      g.delete
    end
  end

  def self.down
    drop_table 'expenses_users'
  end
end
