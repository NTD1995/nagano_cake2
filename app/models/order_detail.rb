class OrderDetail < ApplicationRecord

  belongs_to :order
  belongs_to :item

  enum status: {
    not_production: 0,
    wait_production: 1,
    in_production: 2,
    done_production: 3,
  }

  # 注文詳細ごとの小計を算出する
  def order_detail_subtotal
    purchase_price * quantity
  end

end