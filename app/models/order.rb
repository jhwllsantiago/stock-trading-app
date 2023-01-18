class Order < ApplicationRecord
  scope :buy, -> { where("action = 0") }
  scope :sell, -> { where("action = 1") }
  scope :pending, -> { where("status = 0") }
  enum action: [:buy, :sell]
  enum status: [:pending, :success, :expired]
  belongs_to :user
  belongs_to :stock
  validates :action, :quantity, :price, presence: true
end
