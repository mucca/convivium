module ExpensesHelper
  def can_edit_expense(expense)
    user = User.find session[:user_id]
    if user != expense.creator
      false
    else
      true
    end    
  end
  
end 
