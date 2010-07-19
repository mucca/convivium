class ReportController < ApplicationController
  
  before_filter :login_required
  
  def expense_report
    @user = current_user
    if params[:id].to_i != 0
      @year = params[:id].to_i
    else
      @year = Date.today.year
    end
    
    start_date = Date.new y = @year, m=1, d=1
    end_date = start_date + 1.year
    @expenses = Expense.find :all, :conditions => {:reference_date=>start_date..end_date}, :order=>'reference_date'
    @monthly_expense = {}
    for ex in @expenses
      key = ex.reference_date.month# "#{ex.reference_date.month}-#{ex.reference_date.year}"
      if not @monthly_expense.keys.include? key
        @monthly_expense[key] = 0
      end
      @monthly_expense[key] += ex.amount / ex.users.length 
    end
  end
  
  def history
    @user = current_user
    if params[:id].to_i != 0
      @year = params[:id].to_i
    else
      @year = Date.today.year
    end
    start_date = Date.new y = @year, m=1, d=1
    end_date = start_date + 1.year - 1.day
    for user in User.all
      @history = {}
      user_total = 0
      user_stats = {}
      expense_list = Expense.between(start_date, end_date).related_to_user(@user)
      # WARNING : the oreder metter because i'm using a single variable to 
      # sum and subtract the user_total for the group
      for e in expense_list.all(:order => 'reference_date ASC')
        user_total += e.influence @user
        user_stats[e.reference_date] = user_total
      end
      @history[user] = user_stats
    end
  end
  
  def list
    # TODO filter the expenses the user can see
    @date = DateTime.parse params[:date]
    @expenses = Expense.between(@date-1.day, @date)
    render :layout=>false
  end
  
  def category_report
    @user = current_user
    @expenses = Expense.find :all, :conditions => {}, :order=>'reference_date'
    categories = {}
    for ex in @expenses:
      if categories.keys.include? ex.category.name
        categories[ex.categoty.name] = 0
      end
      categories[key] += ex.amount / ex.users.length 
    end
    for category in categories.keys
    end
  end
  
  def expense_list_month
    month = Integer(params[:id])
    @user = current_user
    start_date = Date.new y=Date.today.year, m=month, d=1
    end_date = start_date + 1.month - 1.day
    @expenses = Expense.find :all, :conditions => { :reference_date=>start_date..end_date }, :order=>'reference_date'
    render :layout=>false 
  end

end
