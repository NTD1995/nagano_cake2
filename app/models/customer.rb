class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :addresses
  has_many :favorites, dependent: :destroy
  has_many :favorite_items, through: :favorites, source: :item
  has_many :reviews, dependent: :destroy

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :post_code, format: {with: /\A\d{7}\z/}, presence: true
  validates :address, presence: true
  validates :phone_number, format: {with: /\A\d{10,11}\z/}, presence: true
  validates :email, presence: true

  def active?
    self.is_active
  end

  def self.search(keyword, match_type)
    return all if keyword.blank?

    case match_type
    when 'exact'
      where('last_name = ? OR first_name = ?', keyword, keyword)
    when 'partial'
      where('last_name LIKE ? OR first_name LIKE ?', "%#{keyword}%", "%#{keyword}%")
    when 'forward'
      where('last_name LIKE ? OR first_name LIKE ?', "#{keyword}%", "#{keyword}%")
    when 'backward'
      where('last_name LIKE ? OR first_name LIKE ?', "%#{keyword}", "%#{keyword}")
    else
      none
    end
  end  
end
