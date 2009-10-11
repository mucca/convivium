class ReportController < ApplicationController
  
  def expense_report
    @user = User.find session[:user_id]
    @expensegroups = @user.expensegroups
    @expenses = Expense.find :all, :conditions => { :expensegroup_id => @expensegroups }, :order=>'reference_date'
    @monthly_expense = {}
    for ex in @expenses
      if not @monthly_expense.keys.include? ex.reference_date.month
        @monthly_expense[ex.reference_date.month] = 0
      end
      @monthly_expense[ex.reference_date.month] += ex.amount / ex.expensegroup.users.length 
    end
  end
  
  def expense_list_month
    month = Integer(params[:id])
    @user = current_user
    @expensegroups = @user.expensegroups
    start_date = Date.new y=Date.today.year, m=month, d=1
    end_date = start_date + 1.month
    @expenses = Expense.find :all, :conditions => { :expensegroup_id => @expensegroups, :reference_date=>start_date..end_date }, :order=>'reference_date'
    render :layout=>false 
  end

end
