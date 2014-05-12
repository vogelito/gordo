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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140509082729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_items", force: true do |t|
    t.string   "description"
    t.string   "picture_url"
    t.decimal  "price",       precision: 10, scale: 2
    t.boolean  "active",                               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "orders", force: true do |t|
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "food_item_id"
    t.integer  "quantity"
    t.boolean  "delivered",    default: false
    t.boolean  "paid",         default: false
  end

  add_index "orders", ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "cellphone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",               default: false
    t.string   "default_address"
    t.string   "stripe_customer_id"
    t.string   "reset_password_code"
  end

  add_index "users", ["email", "cellphone"], name: "index_users_on_email_and_cellphone", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
