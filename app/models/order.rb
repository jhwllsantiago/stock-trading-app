class Order < ApplicationRecord
  enum action: [:buy, :sell]
  enum status: [:pending, :success, :expired]
  belongs_to :user
  belongs_to :stock
<<<<<<< HEAD
=======
  validates :action, :quantity, :price, presence: true
>>>>>>> development
end
