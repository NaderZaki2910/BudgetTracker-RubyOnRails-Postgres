class Wallet < ApplicationRecord
  has_many :Transactions, class_name: "Transaction", foreign_key: "wallet_id"
  has_many :Transfer, class_name: "Transfer", foreign_key: "sender"
  has_many :Transfer, class_name: "Transfer", foreign_key: "receiver"
end
