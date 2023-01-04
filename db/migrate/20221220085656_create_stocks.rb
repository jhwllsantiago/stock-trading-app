class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.float :price
      t.string :company

      t.timestamps
    end
  end
end
