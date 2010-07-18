class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :role_id, :user_id, :null => false
      t.timestamps
    end
    user = User.new
    user.login = "admin"
    user.email = "info@yourapplication.com"
    user.password = "admin"
    user.password_confirmation = "admin"
    user.save(false)
    role = Role.find_by_name('admin')
    user = User.find_by_login('admin')
    permission = Permission.new
    permission.role = role
    permission.user = user
    permission.save(false)
  end
 
  def self.down
    drop_table :permissions
    Role.find_by_name('admin').destroy   
    User.find_by_login('admin').destroy   
  end
end

