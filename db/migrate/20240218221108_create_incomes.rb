class CreateIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :incomes, primary_key: [:transaction_id, :owner] do |t|
      t.string :owner, null: false
      t.integer :transaction_id
      t.integer :income_source_id

      t.timestamps
    end
    add_foreign_key :incomes, :users, column: :owner, primary_key: :email
    add_foreign_key :incomes, :transactions, column: [:transaction_id, :owner], primary_key: [:transaction_id, :owner]
    add_foreign_key :incomes, :income_sources, column: [:income_source_id, :owner], primary_key: [:income_source_id, :owner]
  end
end
