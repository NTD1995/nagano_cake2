class Review < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true  
end
