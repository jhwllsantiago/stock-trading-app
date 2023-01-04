class Order < ApplicationRecord
  enum action: [:buy, :sell]
  enum status: [:pending, :success, :expired]
  belongs_to :user
  belongs_to :stock
end
