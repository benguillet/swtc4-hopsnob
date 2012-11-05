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

ActiveRecord::Schema.define(:version => 20121105192818) do

  create_table "beers", :force => true do |t|
    t.string   "brand"
    t.string   "name"
    t.string   "style"
    t.string   "country"
    t.string   "city"
    t.string   "state"
    t.string   "malt"
    t.decimal  "ibu"
    t.integer  "abv"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "liquor_stores", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "phone_number"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "products", :force => true do |t|
    t.decimal  "price"
    t.integer  "number_of_items"
    t.decimal  "item_volume"
    t.string   "item_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "liquor_store_id"
    t.integer  "beer_id"
  end

end
