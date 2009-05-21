class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :description
      t.float :amount
      t.text :notes
      t.text :status
      t.text :workflow #hope to use it in a short time
      t.datetime :reference_date
      t.references :creator
      t.references :category
      t.references :expensegroup
      t.references :personal
      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
