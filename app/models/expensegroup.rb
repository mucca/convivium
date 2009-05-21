class Expensegroup < ActiveRecord::Base
    has_and_belongs_to_many :users
    belongs_to :personal , :class_name=>"User"
    has_many :expenses
end
