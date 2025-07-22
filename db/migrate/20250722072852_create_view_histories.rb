class CreateViewHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :view_histories do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  add_index :view_histories, [:customer_id, :item_id], unique: true  
  end
end
