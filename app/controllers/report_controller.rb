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
    @expenses = Expense.related_to_user(current_user).between(start_date, end_date)
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
    
    user_total = {}
    @history = {}
    expense_list = Expense.between(start_date, end_date).related_to_user(@user)
    for expense in expense_list.all(:order => 'reference_date ASC')
      for user in expense.users
        if user != current_user
          if not user_total.include? user
            user_total[user] = 0
          end
          if not @history.include? user
            @history[user] = {}
          end
          user_total[user] += expense.influence current_user
          @history[user][expense.reference_date.to_date.to_time] = user_total[user]
        end
      end
    end
  end
  
  def list
    # TODO filter the expenses the user can see
    @date = Time.parse params[:date]
    @user = User.find(:first , :conditions=>{:id=>params[:user]})
    @expenses = []
    for expense in Expense.related_to_user(current_user).between(@date-1.day, @date+1.day)
      if expense.users.include? @user
        @expenses.push expense
      end
    end
    render :layout => false
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
