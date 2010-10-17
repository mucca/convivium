class ExpenseTagging < ActiveRecord::Migration
  def self.up
    create_table "expenses_users", :id => false do |t|
      t.column "expense_id", :integer, :null => false
      t.column "user_id",  :integer, :null => false
    end
  end

  def self.down
    drop_table 'expenses_users'
  end
end
