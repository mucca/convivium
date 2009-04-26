class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :description
      t.float :amount
      t.references :creator
      t.references :category
      t.references :expensegroup
      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
