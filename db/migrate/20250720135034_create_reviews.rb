class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end
