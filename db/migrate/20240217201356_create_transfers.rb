class CreateTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :transfers, primary_key: [:transfer_id, :owner] do |t|
      t.integer :transfer_id
      t.integer :sender
      t.integer :receiver
      t.string :owner, null: false
      t.decimal :value, precision: 15, scale: 2
      t.timestamps
    end
    add_foreign_key :transfers, :users, column: :owner, primary_key: :email
    add_foreign_key :transfers, :wallets, column: [:sender, :owner], primary_key: [:wallet_id, :owner]
    add_foreign_key :transfers, :wallets, column: [:receiver, :owner], primary_key: [:wallet_id, :owner]
  end
end
