module ExpensegroupsHelper
  
  #TODO add key argument for the user
  def get_user_expensegroups
     user= User.find session[:user_id]
     if user.has_role? :admin
       groups = Expensegroup.find :all, :conditions => { :disabled => false }
     else
       groups = user.expensegroups.find :all, :conditions => { :disabled => false }
     end
  end
  
  def expensegroup_status(expensegroup)
    user = User.find session[:user_id]
    paid = 0
    to_pay = 0
    for expense in expensegroup.expenses.all
      if user == expense.creator
        paid += expense.amount / expensegroup.users.length
      else
        to_pay += expense.amount / expensegroup.users.length
      end
    end
    return paid - to_pay
  end
end
