class Expense < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :category

  has_and_belongs_to_many :users, :uniq => true     
  has_and_belongs_to_many :expensegroups, :uniq => true 
  
  validates_presence_of :amount, :description, :creator, :reference_date
  
  validate do |expense|
    expense.validate_personal_transaction
  end

  def validate_personal_transaction
    if self.personal_transaction
      if self.users.length != 2
        if not self.users.include? self.creator
          errors.add_to_base("The creator must be included in the list")
        end
        if not self.users.count(self.creator_id) == 1
          errors.add_to_base("You have to chose the destinatary of the money")
        end
      end
    end
  end  
  
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
    if self.personal_transaction
      if user == self.creator:
        self.amount
      else 
        self.amount * -1
      end
    else
      amount = self.get_user_amount
      if self.creator == user
        amount
      else
        amount * -1
      end
    end
  end
  
  default_scope :order => 'expenses.reference_date, expenses.id DESC'
  named_scope :last_week, lambda { { :conditions => ['reference_date > ?', 1.week.ago] } }
  named_scope :last_month, lambda { { :conditions => ['reference_date > ?', 1.month.ago] } }
  named_scope :last_period, lambda { { :conditions => ['reference_date > ?', 30.days.ago] } }
  named_scope :last_year, lambda { { :conditions => ['reference_date > ?', 360.days.ago] } }
  named_scope :related_to_group, lambda { |expensegroups|{ :conditions => ['expensegroup_id in (?)', expensegroups] } }
  named_scope :related_to_user, lambda { |user| {:joins => [:users], :conditions=>{ 'expenses_users.user_id' => user.id }}}
  # named_scope :related_to_user, lambda { |user| {:joins => "LEFT JOIN expenses_users ON expenses_users.user_id = " + user.id.to_s }}
  named_scope :between, lambda { |from,to|{ :conditions => ['reference_date > ? and reference_date < ?', from , to ] } }
  named_scope :created_between, lambda { |from,to|{ :conditions => ['expenses.created_at >= ? and expenses.created_at <= ?', from , to ] } }
  named_scope :exclude_creator, lambda { |user|{ :conditions => ['expenses.creator_id != ?', user.id ] } }
  named_scope :search, lambda {|field,value,*op| 
    op = "=" if op.empty? || op.first.nil?
    {:conditions => ["#{field} #{op} ?", value]}
  }
  
end
