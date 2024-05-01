class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :Wallets, class_name: "Wallet", foreign_key: "owner"
  has_many :Transactions, class_name: "Transaction", foreign_key: "owner"
  has_many :Categories, class_name: "Category", foreign_key: "owner"
  has_many :Income_sources, class_name: "Income_source", foreign_key: "owner"
end
