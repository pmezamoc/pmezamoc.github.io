# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_01_155757) do

  create_table "clients", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "company_id"
    t.string "firstname"
    t.string "lastname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.integer "year_founded"
    t.string "industry"
    t.boolean "vc_backed"
    t.string "last_round_type"
    t.integer "valuation"
    t.date "deal_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "compensation_plans", force: :cascade do |t|
    t.string "stock_type"
    t.integer "strike_price"
    t.integer "vesting_years"
    t.integer "cliff"
    t.integer "number_of_options"
    t.integer "value_of_options"
    t.integer "salary"
    t.string "salary_period"
    t.integer "bonus"
    t.integer "employee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
