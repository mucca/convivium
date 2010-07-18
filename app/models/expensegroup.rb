class Expensegroup < ActiveRecord::Base
    has_and_belongs_to_many :users        #users attached can be added and remove, we don't care about that
    belongs_to :group_manager, :class_name => 'User'    #the user that will manage the group (the creator by default)
    belongs_to :personal , :class_name => 'User'
    has_many :expenses    
    
    validates_presence_of :group_manager
    
end
