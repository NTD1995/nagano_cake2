class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }
  validates :interval_days, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w(active paused canceled) }

  # 次回配送日を更新する
  def schedule_next_delivery!
    update!(next_delivery_date: next_delivery_date + interval_days.days)
  end

  # 有効な定期購入スコープ
  scope :active, -> { where(status: "active") }  
end
