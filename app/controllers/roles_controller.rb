class RolesController < ApplicationController
  layout 'application'
  before_filter :check_administrator_role
 
  def index
    @user = User.find(params[:user_id])
    @all_roles = Role.find(:all)
  end
 
  def update
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    unless @user.roles.include?(@role)
      @user.roles << @role
    end
    redirect_to user_roles_path(@user)
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    if @user.roles.include?(@role)
      @user.roles.delete(@role)
    end
    redirect_to user_roles_path(@user)
  end
 
end

