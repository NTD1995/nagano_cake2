class ViewHistory < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :customer_id, uniqueness: { scope: :item_id }
end
