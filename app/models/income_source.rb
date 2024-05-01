class IncomeSource < ApplicationRecord
  has_many :Incomes, class_name: "Income", foreign_key: "income_source_id"
end
