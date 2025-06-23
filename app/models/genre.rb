class Genre < ApplicationRecord
  has_many :item, dependent: :destroy

  validates :name, presence: true  
end
