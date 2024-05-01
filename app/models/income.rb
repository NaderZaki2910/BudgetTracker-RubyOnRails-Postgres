class Income < ApplicationRecord
  belongs_to :Transaction, class_name: "Transaction", foreign_key: "trans_id"
end
