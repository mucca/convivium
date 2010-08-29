module ExpensesHelper
  
  def can_edit_expense(expense)
    user = current_user
    if user == expense.creator or user.has_role? :admin
      return true
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
    expenses = Expense.related_to_user(current_user).exclude_creator(current_user)
    if current_user.previous_login 
      expenses.created_between(current_user.previous_login, Time.now)
    else
      []
    end
  end
    
end 
