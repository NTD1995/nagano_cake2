class CouponUsage < ApplicationRecord
  belongs_to :customer
  belongs_to :coupon
end
