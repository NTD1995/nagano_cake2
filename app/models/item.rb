class Item < ApplicationRecord
  has_one_attached :image
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  has_many :orders, through: :order_details

  belongs_to :genre
  has_one_attached :image
  
  validates :name, presence: true
  validates :introduction, presence: true
  validates :genre_id, presence: true
  validates :price_excluding_tax, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def with_tax_price
    (price_excluding_tax * 1.1).floor
  end

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def self.search(keyword, match_type)
    return all if keyword.blank?

    case match_type
    when 'exact'
      where(name: keyword)
    when 'partial'
      where('name LIKE ?', "%#{keyword}%")
    when 'forward'
      where('name LIKE ?', "#{keyword}%")
    when 'backward'
      where('name LIKE ?', "%#{keyword}")
    else
      none
    end
  end

end
