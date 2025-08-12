class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, default: 1
      t.integer :interval_days, default: 30
      t.date :next_delivery_date
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
