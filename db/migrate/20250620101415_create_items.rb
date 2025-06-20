class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.references :genre, null: false, foreign_key: true
      t.string :name, null: false
      t.text :introduction, null: false
      t.integer :price_excluding_tax, null: false
      t.boolean :is_sale, null: false, default: true

      t.timestamps
    end
  end
end
