class CreateIncomeSources < ActiveRecord::Migration[7.1]
  def change
    create_table :income_sources, primary_key: [:income_source_id, :owner] do |t|
      t.integer :income_source_id
      t.string :name
      t.string :owner, null: false
      t.integer :income_freq_type
      t.date :next_salary_date
      t.boolean :auto_add_next_salary, default:0
      t.decimal :amount, precision: 15, scale: 2
      t.timestamps
    end
    add_foreign_key :income_sources, :users, column: :owner, primary_key: :email
    add_index :income_sources, :name, unique: true
  end
end
