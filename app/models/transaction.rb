class Transaction < ApplicationRecord
  belongs_to :User, class_name: "User", foreign_key: "email"
end
