# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def format_date(date)
    date.strftime "%d/%m/%y"
  end
  
  def is_owner(object)
    if object.methods.include? "creator"
      if object.creator == User.find(session[:user_id])
        true
      end
    end
  end

  def has_role?(role)
    User.find(session[:user_id]).has_role? role
  end
end
