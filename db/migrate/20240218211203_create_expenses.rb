class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses, primary_key: [:transaction_id, :owner] do |t|
      t.string :owner, null: false
      t.integer :transaction_id
      t.integer :category_id

      t.timestamps
    end
    add_foreign_key :expenses, :users, column: :owner, primary_key: :email
    add_foreign_key :expenses, :transactions, column: [:transaction_id, :owner], primary_key: [:transaction_id, :owner]
    add_foreign_key :expenses, :categories, column: [:category_id, :owner], primary_key: [:category_id, :owner]
  end
end
