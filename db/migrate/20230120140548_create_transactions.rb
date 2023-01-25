class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :buyer_id, null: false
      t.bigint :seller_id, null: false
      t.belongs_to :stock, null: false, foreign_key: true
      t.float :price
      t.float :quantity

      t.timestamps
    end
    add_foreign_key :transactions, :users, column: :buyer_id
    add_foreign_key :transactions, :users, column: :seller_id
  end
end
