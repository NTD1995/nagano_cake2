class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details
  has_many :items, through: :order_details

  enum payment_method: { credit_card: 0, transfer: 1 }
  enum status: {
    wait_payment: 0,
    confirm_payment: 1,
    in_production: 2,
    in_shipping: 3,
    done_shipping:4
  }

  def self.payment_method_i18n
    payment_methods.keys.index_with do |key|
      I18n.t("enums.order.payment_method.#{key}")
    end.symbolize_keys
  end

  def self.status_i18n
    status.keys.index_with do |key|
      I18n.t("enums.order.status.#{key}")
    end.symbolize_keys
  end

  # order_idごとに商品の注文個数合計を算出する
  def sum_quantity(resource)
    order_detail_find_by_id = OrderDetail.where(order_id: resource)
    sum = 0

    for i in order_detail_find_by_id do
      sum += i.quantity
    end
    return sum
  end  
end
