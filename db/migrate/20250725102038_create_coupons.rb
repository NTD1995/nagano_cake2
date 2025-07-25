class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.integer :discount_price, null: false
      t.integer :minimum_order_amount, null: false, default: 0
      t.boolean :is_active, default: true
      t.datetime :valid_from
      t.datetime :valid_until
      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
