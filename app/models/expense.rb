class Expense < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :category
  belongs_to :expensegroup  
  
  validates_presence_of :amount, :description, :expensegroup, :creator, :reference_date
  
  def self.per_page
    15
  end

  def get_user_amount user=nil
    self.amount / self.expensegroup.users.length
  end
  
  default_scope :order => 'reference_date DESC'
  named_scope :last_week, lambda { { :conditions => ['reference_date > ?', 1.week.ago] } }
  named_scope :last_month, lambda { { :conditions => ['reference_date > ?', 1.month.ago] } }
  named_scope :related_to_group, lambda { |expensegroups|{ :conditions => ['expensegroup_id in (?)', expensegroups] } }
  
  
end
