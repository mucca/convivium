# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def format_date(date)
    date.strftime "%d/%m/%y"
  end

  def format_number(number)
    number_with_precision number, :precision=>2, :separator => '.'
  end
  
  def is_owner(object)
    if object.methods.include? "creator"
      if object.creator == User.find(session[:user_id])
        true
      end
    end
  end

  def name_or_login user
    if user.name?
      user.name
    else
      user.login
    end
  end

  def has_role?(role)
    current_user.has_role? role
  end
  
  def global_portlets
    if current_user
      [ render(:partial=>'portlets/credit_status'), 
        render(:partial=>'portlets/last_transactions') ]
    else
      []
    end
  end
  
  def user_portlets
    []
  end
end
