namespace :subscriptions do
  desc "本日配送予定の定期購入を処理"
  task process: :environment do
    Subscription.active.where(next_delivery_date: Date.today).find_each do |sub|
      Order.create!(
        customer: sub.customer,
        item: sub.item,
        quantity: sub.quantity,
        total_price: sub.item.price * sub.quantity
      )
      sub.schedule_next_delivery!
    end
  end
end
