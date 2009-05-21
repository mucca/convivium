module CategoriesHelper
  def get_user_categories_for_expense(expense)
    if current_user != expense.creator
      user = expense.creator
    else
      user = current_user
    end
    user.categories + Category.find( :all, :conditions =>{:creator_id=>nil} )
  end
end
