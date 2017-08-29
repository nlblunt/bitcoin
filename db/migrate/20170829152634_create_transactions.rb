class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :from_id
      t.integer :to_id
      t.float :amount
      t.timestamps
    end
  end
end
