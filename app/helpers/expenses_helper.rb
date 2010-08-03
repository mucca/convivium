module ExpensesHelper
  
  def can_edit_expense(expense)
    user = User.find session[:user_id]
    if user != expense.creator
      false
    else
      true
    end    
  end
  
  def get_credit_status
    status = {}
    for e in Expense.related_to_user current_user
      for user in e.users:
        if user != current_user
          if not status.key? user
            status[user] = 0
          end
          status[user] = status[user] + e.influence(current_user)
        end
      end
    end
    return status
  end

  def transactions_from_last_visit
    expenses = Expense.related_to_user(current_user)
    if current_user.previous_login 
      expenses.created_between(current_user.previous_login, Time.now)
    else
      []
    end
  end
    
end 
