# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_24_210521) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", primary_key: ["category_id", "owner"], force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "name"
    t.string "owner", null: false
    t.integer "child_of"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", primary_key: ["transaction_id", "owner"], force: :cascade do |t|
    t.string "owner", null: false
    t.integer "transaction_id", null: false
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "income_sources", primary_key: ["income_source_id", "owner"], force: :cascade do |t|
    t.integer "income_source_id", null: false
    t.string "name"
    t.string "owner", null: false
    t.integer "income_freq_type"
    t.date "next_salary_date"
    t.boolean "auto_add_next_salary", default: false
    t.decimal "amount", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incomes", primary_key: ["transaction_id", "owner"], force: :cascade do |t|
    t.string "owner", null: false
    t.integer "transaction_id", null: false
    t.integer "income_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", primary_key: ["transaction_id", "owner"], force: :cascade do |t|
    t.integer "transaction_id", null: false
    t.string "owner", null: false
    t.integer "wallet_id"
    t.integer "type"
    t.decimal "value", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfers", primary_key: ["transfer_id", "owner"], force: :cascade do |t|
    t.integer "transfer_id", null: false
    t.integer "sender"
    t.integer "receiver"
    t.string "owner", null: false
    t.decimal "value", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "email", id: :string, default: "", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", primary_key: ["wallet_id", "owner"], force: :cascade do |t|
    t.integer "wallet_id", null: false
    t.string "name"
    t.text "description"
    t.string "owner", null: false
    t.decimal "amount", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "categories", column: ["child_of", "owner"], primary_key: ["category_id", "owner"]
  add_foreign_key "categories", "users", column: "owner", primary_key: "email"
  add_foreign_key "expenses", "categories", column: ["category_id", "owner"], primary_key: ["category_id", "owner"]
  add_foreign_key "expenses", "transactions", column: ["transaction_id", "owner"], primary_key: ["transaction_id", "owner"]
  add_foreign_key "expenses", "users", column: "owner", primary_key: "email"
  add_foreign_key "income_sources", "users", column: "owner", primary_key: "email"
  add_foreign_key "incomes", "income_sources", column: ["income_source_id", "owner"], primary_key: ["income_source_id", "owner"]
  add_foreign_key "incomes", "transactions", column: ["transaction_id", "owner"], primary_key: ["transaction_id", "owner"]
  add_foreign_key "incomes", "users", column: "owner", primary_key: "email"
  add_foreign_key "transactions", "users", column: "owner", primary_key: "email"
  add_foreign_key "transactions", "wallets", column: ["wallet_id", "owner"], primary_key: ["wallet_id", "owner"]
  add_foreign_key "transfers", "users", column: "owner", primary_key: "email"
  add_foreign_key "transfers", "wallets", column: ["receiver", "owner"], primary_key: ["wallet_id", "owner"]
  add_foreign_key "transfers", "wallets", column: ["sender", "owner"], primary_key: ["wallet_id", "owner"]
  add_foreign_key "wallets", "users", column: "owner", primary_key: "email"
end
