class Expense < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :category
  belongs_to :expensegroup  
  #validates_presence_of :amount, :description
  
  
end
