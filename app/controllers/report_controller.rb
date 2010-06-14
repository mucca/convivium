class ReportController < ApplicationController
  require_role :user
  
  def expense_report
    @user = current_user
    if params[:id].to_i != 0
      @year = params[:id].to_i
    else
      @year = Date.today.year
    end
    
    start_date = Date.new y = @year, m=1, d=1
    end_date = start_date + 1.year
    @expensegroups = @user.expensegroups
    @expenses = Expense.find :all, :conditions => { :expensegroup_id => @expensegroups , :reference_date=>start_date..end_date}, :order=>'reference_date'
    @monthly_expense = {}
    for ex in @expenses
      key = ex.reference_date.month# "#{ex.reference_date.month}-#{ex.reference_date.year}"
      if not @monthly_expense.keys.include? key
        @monthly_expense[key] = 0
      end
      @monthly_expense[key] += ex.amount / ex.expensegroup.users.length 
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
    @expensegroups = @user.expensegroups
    @history = {}
    for g in @expensegroups
      total = 0
      group_stats = {}
      for e in Expense.between(start_date, end_date).related_to_group(g)
        total += e.influence current_user
        group_stats[e.reference_date] = total
      end
      if not group_stats.empty? and not g.personal
        @history[g] = group_stats
      end
    end
    
  end
  
  def category_report
    @user = current_user
    @expensegroups = @user.expensegroups
    @expenses = Expense.find :all, :conditions => { :expensegroup_id => @expensegroups }, :order=>'reference_date'
    categories = {}
    for ex in @expenses:
      if categories.keys.include? ex.category.name
        categories[ex.categoty.name] = 0
      end
      categories[key] += ex.amount / ex.expensegroup.users.length 
    end
    for category in categories.keys
    end
  end
  
  def expense_list_month
    month = Integer(params[:id])
    @user = current_user
    @expensegroups = @user.expensegroups
    start_date = Date.new y=Date.today.year, m=month, d=1
    end_date = start_date + 1.month - 1.day
    @expenses = Expense.find :all, :conditions => { :expensegroup_id => @expensegroups, :reference_date=>start_date..end_date }, :order=>'reference_date'
    render :layout=>false 
  end

end
