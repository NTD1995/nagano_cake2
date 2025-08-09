class CreateRestockRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :restock_requests do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.boolean :notified, default: false
      
      t.timestamps
    end
    add_index :restock_requests, [:customer_id, :item_id], unique: true   
  end
end
