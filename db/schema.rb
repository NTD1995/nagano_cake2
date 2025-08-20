# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_08_11_132837) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "post_code", null: false
    t.string "address", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_cart_items_on_customer_id"
    t.index ["item_id"], name: "index_cart_items_on_item_id"
  end

  create_table "comparisons", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "item_id"], name: "index_comparisons_on_customer_id_and_item_id", unique: true
    t.index ["customer_id"], name: "index_comparisons_on_customer_id"
    t.index ["item_id"], name: "index_comparisons_on_item_id"
  end

  create_table "coupon_usages", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "coupon_id", null: false
    t.datetime "used_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_id"], name: "index_coupon_usages_on_coupon_id"
    t.index ["customer_id", "coupon_id"], name: "index_coupon_usages_on_customer_id_and_coupon_id", unique: true
    t.index ["customer_id"], name: "index_coupon_usages_on_customer_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code", null: false
    t.integer "discount_price", null: false
    t.integer "minimum_order_amount", default: 0, null: false
    t.boolean "is_active", default: true
    t.datetime "valid_from"
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "last_name", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name_kana", default: "", null: false
    t.string "first_name_kana", default: "", null: false
    t.string "post_code", default: "", null: false
    t.string "address", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "item_id"], name: "index_favorites_on_customer_id_and_item_id", unique: true
    t.index ["customer_id"], name: "index_favorites_on_customer_id"
    t.index ["item_id"], name: "index_favorites_on_item_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "genre_id", null: false
    t.string "name", null: false
    t.text "introduction", null: false
    t.integer "price_excluding_tax", null: false
    t.boolean "is_sale", default: true, null: false
    t.integer "stock", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["genre_id"], name: "index_items_on_genre_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_notifications_on_customer_id"
    t.index ["item_id"], name: "index_notifications_on_item_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "item_id", null: false
    t.integer "purchase_price", null: false
    t.integer "quantity", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_order_details_on_item_id"
    t.index ["order_id"], name: "index_order_details_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "post_code", null: false
    t.string "address", null: false
    t.string "name", null: false
    t.integer "shipping_fee", null: false
    t.integer "total_price", null: false
    t.integer "payment_method", null: false
    t.integer "status", default: 0, null: false
    t.integer "discount_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restock_requests", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.boolean "notified", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "item_id"], name: "index_restock_requests_on_customer_id_and_item_id", unique: true
    t.index ["customer_id"], name: "index_restock_requests_on_customer_id"
    t.index ["item_id"], name: "index_restock_requests_on_item_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.integer "rating", null: false
    t.text "comment", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_reviews_on_customer_id"
    t.index ["item_id"], name: "index_reviews_on_item_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.integer "quantity", default: 1
    t.integer "interval_days", default: 30
    t.date "next_delivery_date"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["item_id"], name: "index_subscriptions_on_item_id"
  end

  create_table "view_histories", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "item_id"], name: "index_view_histories_on_customer_id_and_item_id", unique: true
    t.index ["customer_id"], name: "index_view_histories_on_customer_id"
    t.index ["item_id"], name: "index_view_histories_on_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "customers"
  add_foreign_key "cart_items", "items"
  add_foreign_key "comparisons", "customers"
  add_foreign_key "comparisons", "items"
  add_foreign_key "coupon_usages", "coupons"
  add_foreign_key "coupon_usages", "customers"
  add_foreign_key "favorites", "customers"
  add_foreign_key "favorites", "items"
  add_foreign_key "items", "genres"
  add_foreign_key "notifications", "customers"
  add_foreign_key "notifications", "items"
  add_foreign_key "restock_requests", "customers"
  add_foreign_key "restock_requests", "items"
  add_foreign_key "reviews", "customers"
  add_foreign_key "reviews", "items"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "items"
  add_foreign_key "view_histories", "customers"
  add_foreign_key "view_histories", "items"
end
