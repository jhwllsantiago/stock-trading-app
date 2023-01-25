class ChangeQuantityToBeFloatInAssets < ActiveRecord::Migration[7.0]
  def up
    change_column :assets, :quantity, :float
  end

  def down
    change_column :assets, :quantity, :integer
  end
end
