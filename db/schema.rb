# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100802215934) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expensegroups", :force => true do |t|
    t.string   "name"
    t.integer  "personal_id"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_manager_id"
  end

  create_table "expensegroups_expenses", :id => false, :force => true do |t|
    t.integer "expensegroup_id", :null => false
    t.integer "expense_id",      :null => false
  end

  create_table "expensegroups_users", :id => false, :force => true do |t|
    t.integer  "expensegroup_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", :force => true do |t|
    t.string   "description"
    t.float    "amount"
    t.text     "notes"
    t.text     "status"
    t.text     "workflow"
    t.datetime "reference_date"
    t.integer  "creator_id"
    t.integer  "category_id"
    t.integer  "expensegroup_id"
    t.integer  "personal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses_users", :id => false, :force => true do |t|
    t.integer "expense_id", :null => false
    t.integer "user_id",    :null => false
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "encrypted_password",        :limit => 128
    t.string   "confirmation_token",        :limit => 128
    t.boolean  "email_confirmed",                          :default => false, :null => false
    t.datetime "last_login"
    t.datetime "previous_login"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
