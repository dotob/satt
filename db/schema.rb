# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120802105857) do

  create_table "master_orders", :force => true do |t|
    t.datetime "date_of_order"
    t.boolean  "deadline_crossed"
    t.integer  "user_id"
    t.integer  "menu_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "master_orders", ["menu_id"], :name => "index_master_orders_on_menu_id"
  add_index "master_orders", ["user_id"], :name => "index_master_orders_on_user_id"

  create_table "menu_items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price"
    t.integer  "order_count"
    t.integer  "menu_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "order_number"
  end

  add_index "menu_items", ["menu_id"], :name => "index_menu_items_on_menu_id"

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "phone"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "order_items", :force => true do |t|
    t.text     "special_wishes"
    t.integer  "user_order_id"
    t.integer  "menu_item_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "order_items", ["menu_item_id"], :name => "index_order_items_on_menu_item_id"
  add_index "order_items", ["user_order_id"], :name => "index_order_items_on_user_order_id"

  create_table "user_orders", :force => true do |t|
    t.boolean  "paid"
    t.integer  "master_order_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_orders", ["master_order_id"], :name => "index_user_orders_on_master_order_id"
  add_index "user_orders", ["user_id"], :name => "index_user_orders_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
