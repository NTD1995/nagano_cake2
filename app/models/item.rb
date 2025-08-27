class Item < ApplicationRecord
  has_one_attached :image
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  has_many :orders, through: :order_details
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :customer
  has_many :reviews, dependent: :destroy
  has_many :view_histories, dependent: :destroy
  has_many :viewed_customers, through: :view_histories, source: :customer
  has_many :comparisons, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :restock_requests, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

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

  after_update :create_restock_notifications, if: :restocked?

   # 🔍 キーワード検索
  scope :by_keyword, ->(keyword) {
    where("name LIKE :kw OR introduction LIKE :kw", kw: "%#{keyword}%") if keyword.present?
  }

  # 🎯 ジャンルで絞り込み
  scope :by_genre, ->(genre_id) {
    where(genre_id: genre_id) if genre_id.present?
  }

  # 💰 価格帯
  scope :by_price_range, ->(min, max) {
    if min.present? && max.present?
      where(price_excluding_tax: min..max)
    elsif min.present?
      where("price_excluding_tax >= ?", min)
    elsif max.present?
      where("price_excluding_tax <= ?", max)
    end
  }

  # 📦 在庫あり
  scope :in_stock, -> {
    where("stock > 0")
  }

  # ↕ 並び替え
  scope :sorted, ->(sort_param) {
    case sort_param
    when "newest"
      order(created_at: :desc)
    when "price_asc"
      order(price_excluding_tax: :asc)
    when "price_desc"
      order(price_excluding_tax: :desc)
    else
      order(created_at: :desc)
    end
  }


  private

  # 在庫が0から1以上になったか判定
  def restocked?
    saved_change_to_stock? && stock > 0 && stock_before_last_save == 0
  end

  # 再入荷通知を作成
  def create_restock_notifications
    restock_requests.where(notified: false).find_each do |request|
      Notification.create!(
        customer_id: request.customer_id,
        item_id: id,
        message: "#{name}が再入荷しました！",
        read: false
      )
      request.update!(notified: true) # 二重通知防止
    end
  end  

  
end
