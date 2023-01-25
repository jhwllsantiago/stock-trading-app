class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, :last_name, presence: true
  enum role: [:trader, :admin]
  has_many :orders
  has_many :assets
  has_many :buyer_transactions, class_name: 'Transaction', foreign_key: 'buyer_id'
  has_many :seller_transactions, class_name: 'Transaction', foreign_key: 'seller_id'

  # def active_for_authentication? 
  #   super && approved?
  # end 
    
  # def inactive_message 
  #   approved? ? super : :not_approved
  # end
end
