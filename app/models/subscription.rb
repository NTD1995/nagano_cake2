class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }
  validates :interval_days, numericality: { greater_than: 0 }

  enum status: { active: 0, canceled: 1 }

  def process_order!
    # 注文を作成
    order = customer.orders.create!(
      order_date: Date.today,
      total_price: item.price_excluding_tax * 1.1,
      payment_method: 'credit_card', # 必要に応じて固定値や設定値
      status: 'pending'
    )

    # 注文明細を作成
    order.order_details.create!(
      item: item,
      quantity: quantity,
      price: item.price_excluding_tax
    )

    # 次回配送日を更新
    update!(next_delivery_date: next_delivery_date + interval_days.days)
  end


  # 次回配送日を更新する
  def schedule_next_delivery!
    update!(next_delivery_date: next_delivery_date + interval_days.days)
  end

  # 有効な定期購入スコープ
  scope :active, -> { where(status: "active") }  
end
