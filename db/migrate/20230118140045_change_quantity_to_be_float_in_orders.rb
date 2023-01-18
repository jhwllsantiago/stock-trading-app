class ChangeQuantityToBeFloatInOrders < ActiveRecord::Migration[7.0]
  def up
    change_column :orders, :quantity, :float
  end

  def down
    change_column :orders, :quantity, :integer
  end
end
