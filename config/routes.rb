ActionController::Routing::Routes.draw do |map|
  map.resources :expensegroups
  map.resources :categories
  map.connect 'expenses/users_autocomplete', :controller => 'expenses', :action => 'users_autocomplete'
  map.connect 'expenses/users_and_groups_autocomplete', :controller => 'expenses', :action => 'users_and_groups_autocomplete'     
  map.connect 'expenses/group_users', :controller => 'expenses', :action => 'group_users'  
  map.connect 'expenses/groups_autocomplete', :controller => 'expenses', :action => 'groups_autocomplete'
  map.connect 'expenses/list', :controller => 'expenses', :action => 'list'
  map.resources :expenses
  
  #map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'

  map.resources :roles 
  
  map.resources :users, :member => { :enable => :put } do |users|
    users.resource :account
    users.resources :roles
  end

  map.resource :session
  map.resource :reports
    
  map.root :controller => "expenses"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
