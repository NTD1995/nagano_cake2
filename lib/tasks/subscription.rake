namespace :subscriptions do
  desc "本日配送予定の定期購入を処理"
  task process: :environment do
    Subscription.active.where(next_delivery_date: Date.today).find_each do |sub|
      # 注文作成
      order = sub.customer.orders.create!(
        order_date: Date.today,
        total_price: sub.item.price_excluding_tax * sub.quantity * 1.1, # 税込
        payment_method: 'credit_card', # 固定 or ユーザー設定
        status: 'pending' # enumの値に合わせる
      )

      # 注文明細作成
      order.order_details.create!(
        item: sub.item,
        quantity: sub.quantity,
        price: sub.item.price_excluding_tax
      )

      # 次回配送日を更新
      sub.schedule_next_delivery!
    end
  end
end
