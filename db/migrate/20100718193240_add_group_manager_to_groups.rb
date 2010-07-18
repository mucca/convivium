class AddGroupManagerToGroups < ActiveRecord::Migration
  def self.up    
    add_column :expensegroups, :group_manager_id, :integer  
  end

  def self.down  
    remove_column :expensegroups, :group_manager_id
  end
end
