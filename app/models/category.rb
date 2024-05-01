class Category < ApplicationRecord
  has_many :Expenses, class_name: "Expense", foreign_key: "category_id"
end
