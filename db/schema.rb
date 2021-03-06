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

ActiveRecord::Schema.define(version: 20160620153717) do

  create_table "balances", force: :cascade do |t|
    t.float    "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "iso_code"
    t.float    "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rate_comparisons", force: :cascade do |t|
    t.integer "currency_one_id"
    t.integer "currency_two_id"
  end

  create_table "trades", force: :cascade do |t|
    t.string   "direction"
    t.integer  "rate_comparison_id"
    t.float    "enter_rate"
    t.float    "exit_rate"
    t.float    "interest_rate"
    t.float    "interest_value"
    t.datetime "closed_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
