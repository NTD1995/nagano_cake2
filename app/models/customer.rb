class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :addresses

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

end
