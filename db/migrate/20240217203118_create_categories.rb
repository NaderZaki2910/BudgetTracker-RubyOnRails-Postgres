class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories, primary_key: [:category_id, :owner] do |t|
      t.integer :category_id
      t.string :name
      t.string :owner, null: false
      t.integer :child_of, null:true
      t.timestamps
    end
    add_foreign_key :categories, :users, column: :owner, primary_key: :email
    add_foreign_key :categories, :categories, column: [:child_of, :owner], primary_key: [:category_id, :owner]
    add_index :categories, :name, unique: true
  end
end
