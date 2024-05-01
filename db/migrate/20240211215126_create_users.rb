class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, primary_key: [:email] do |t|
      t.string :name
      t.string :email, null: false, default: ""
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
