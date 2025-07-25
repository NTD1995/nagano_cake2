class CreateCouponUsages < ActiveRecord::Migration[6.1]
  def change
    create_table :coupon_usages do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :coupon, null: false, foreign_key: true
      t.datetime :used_at
      t.timestamps
    end

    add_index :coupon_usages, [:customer_id, :coupon_id], unique: true
  end
end
