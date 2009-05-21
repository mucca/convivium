class Expense < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :category
  belongs_to :expensegroup  
  
  validates_presence_of :amount, :description, :expensegroup, :creator, :reference_date
  
  def self.per_page
    15
  end
  
end
