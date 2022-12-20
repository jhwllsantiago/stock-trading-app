class AddDetailsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :float, default: 0.00
    add_column :users, :role, :integer, default: 0
    add_column :users, :active, :boolean, default: false
  end
end
