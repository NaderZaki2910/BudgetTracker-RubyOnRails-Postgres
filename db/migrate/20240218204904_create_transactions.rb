class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, primary_key: [:transaction_id, :owner] do |t|
      t.integer :transaction_id
      t.string :owner, null: false
      t.integer :wallet_id
      t.integer :type
      t.decimal :value, precision: 15, scale: 2
      t.timestamps
    end
    add_foreign_key :transactions, :users, column: :owner, primary_key: :email
    add_foreign_key :transactions, :wallets, column: [:wallet_id, :owner], primary_key: [:wallet_id, :owner]
  end
end
