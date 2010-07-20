class Expense < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :category
  belongs_to :expensegroup  
  has_and_belongs_to_many :users
  
  validates_presence_of :amount, :description, :creator, :reference_date
  
  def formatted_reference_date
    format_date self.reference_date
  end
  
  def self.per_page
    15
  end

  def get_user_amount
    self.amount / self.users.length
  end
  
  def influence user=nil
    amount = self.get_user_amount
    if self.creator == user
      amount
    else
      amount * -1
    end
  end
  
  default_scope :order => 'reference_date, id DESC'
  named_scope :last_week, lambda { { :conditions => ['reference_date > ?', 1.week.ago] } }
  named_scope :last_month, lambda { { :conditions => ['reference_date > ?', 1.month.ago] } }
  named_scope :related_to_group, lambda { |expensegroups|{ :conditions => ['expensegroup_id in (?)', expensegroups] } }
  named_scope :related_to_user, lambda { |user|{:joins => [:users], :conditions=>{ 'expenses_users.user_id'=>user.id}}}
  named_scope :between, lambda { |from,to|{ :conditions => ['reference_date > ? and reference_date < ?', from , to ] } }  
  named_scope :search, lambda {|field,value,*op| 
    op = "=" if op.empty? || op.first.nil?
    {:conditions => ["#{field} #{op} ?", value]}
  }
  
end
