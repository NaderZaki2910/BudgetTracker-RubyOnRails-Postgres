class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets, primary_key: [:wallet_id, :owner] do |t|
      t.integer :wallet_id
      t.string :name
      t.text :description
      t.string :owner, null: false
      t.decimal :amount, precision: 15, scale: 2
      t.timestamps
    end
    add_foreign_key :wallets, :users, column: :owner, primary_key: :email
  end
end
