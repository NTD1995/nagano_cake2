class Coupon < ApplicationRecord
  has_many :coupon_usages, dependent: :destroy
  has_many :customers, through: :coupon_usages

  validates :code, presence: true, uniqueness: true

  def available_for?(customer, order_total)
    is_active &&
      order_total >= minimum_order_amount &&
      !coupon_usages.exists?(customer: customer)
  end  
end
