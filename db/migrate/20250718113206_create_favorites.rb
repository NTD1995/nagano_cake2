class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
    # 同じ会員が同じ商品を複数回お気に入り登録できないように
    add_index :favorites, [:customer_id, :item_id], unique: true    
  end
end
