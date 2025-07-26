class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new # 注文情報入力画面(支払方法・配送先の選択)/注文確定処理
    @customer = current_customer
    @order = Order.new
  end

  def confirm # 注文情報確認画面
    @customer = current_customer
    @cart_items = current_customer.cart_items
    @shipping_fee = 800
    @selected_payment_method = params[:order][:payment_method]
    @address_type = params[:order][:address_type]

    @cart_items_price = @cart_items.sum do |item|
      (item.item.price_excluding_tax * 1.1).floor * item.amount
    end

    @total_price = @cart_items_price + @shipping_fee

    # クーポン適用処理
    coupon_code = params[:order][:coupon_code]
    coupon = Coupon.find_by(code: coupon_code)
    if coupon && coupon.available_for?(current_customer, @total_price)
      @discount_amount = coupon.discount_price
      @total_price -= @discount_amount
      @applied_coupon = coupon
    end

    # 配送先の処理
    case @address_type
    when "customer_address"
      @selected_address = current_customer.post_code + " " + current_customer.address
      @selected_name = current_customer.last_name + current_customer.first_name
    when "registered_address"
      selected = Address.find_by(id: params[:order][:registered_address_id])
      if selected
        @selected_address = selected.post_code + " " + selected.address
        @selected_name = selected.name
      else
        render :new
      end
    when "new_address"
      if params[:order][:new_post_code].present? && params[:order][:new_address].present? && params[:order][:new_name].present?
        @selected_address = params[:order][:new_post_code] + " " + params[:order][:new_address]
        @selected_name = params[:order][:new_name]
      else
        render :new
      end
    end

    # 必要情報をhiddenで渡すため保存しない
    @order = Order.new(order_params)
  end

  def create # 注文情報入力画面(支払方法・配送先の選択)/注文確定処理
    @customer = current_customer
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping_fee = 800

    cart_items_price = @cart_items.sum do |item|
      (item.item.price_excluding_tax * 1.1).floor * item.amount
    end

    total_price = cart_items_price + @order.shipping_fee

    # クーポン適用
    coupon = Coupon.find_by(code: params[:order][:coupon_code])
    if coupon && coupon.available_for?(current_customer, total_price)
      @order.total_price = total_price - coupon.discount_price
    else
      @order.total_price = total_price
      coupon = nil
    end

    @order.payment_method = params[:order][:payment_method].presence || "credit_card"
    @order.status = 0

    case params[:order][:address_type]
    when "customer_address"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    when "registered_address"
      selected = Address.find(params[:order][:registered_address_id])
      @order.post_code = selected.post_code
      @order.address = selected.address
      @order.name = selected.name
    when "new_address"
      @order.post_code = params[:order][:new_post_code]
      @order.address = params[:order][:new_address]
      @order.name = params[:order][:new_name]
    end

    if @order.save
      @cart_items.each do |cart_item|
        OrderDetail.create!(
          order: @order,
          item: cart_item.item,
          purchase_price: (cart_item.item.price_excluding_tax * 1.1).floor,
          quantity: cart_item.amount,
          status: 0
        )
      end

      @cart_items.destroy_all

      # クーポン使用履歴保存
      if coupon
        CouponUsage.create!(customer: current_customer, coupon: coupon, used_at: Time.current)
      end

      redirect_to thanks_orders_path
    else
      render :new
    end
  end

  def index # 注文履歴画面
    @customer = current_customer
    @orders = current_customer.orders.order(created_at: :desc)
    @orders.each do |order|
      details = order.order_details
      cart_price = details.sum { |d| d.purchase_price * d.quantity }
      order.total_price = cart_price + order.shipping_fee  # 合計金額を計算
    end
  end

  def show # 注文履歴詳細画面
    @customer = current_customer
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @shipping_fee = @order.shipping_fee
    @cart_items_price = @order_details.sum { |detail| detail.purchase_price * detail.quantity }
    @total_price = @cart_items_price + @shipping_fee
  end

  def thanks # 注文完了画面
    @customer = current_customer
  end

  private

  def order_params
    params.require(:order).permit(
      :payment_method,
      :shipping_address,
      :total_price,
    )
  end
end









# class Public::OrdersController < ApplicationController
#   before_action :authenticate_customer!

#   def new # 注文情報入力画面(支払方法・配送先の選択)/注文確定処理
#     # viweページのみ
#     # 処理はcreateに記述
#     @customer = current_customer
#     @order = Order.new
#   end

#   def confirm # 注文情報確認画面
#     @customer = current_customer
#     @cart_items = CartItem.where(customer_id: current_customer.id)
#     @shipping_fee = 800
#     @selected_payment_method = params[:order][:payment_method]

#     # 商品合計額の計算
#     ary = []
#     @cart_items.each do |cart_item|
#       ary << (cart_item.item.price_excluding_tax * 1.1).floor * cart_item.amount
#     end
#     @cart_items_price = ary.sum # 商品の小計
#     @total_price = @shipping_fee + @cart_items_price # 商品の小計+送料

#     # 配送先の指定
#     @address_type = params[:order][:address_type]
#     case @address_type
#     when "customer_address" # 会員登録の住所に配送
#       @selected_address = current_customer.post_code + " " + current_customer.address + " "
#       @selected_name = current_customer.last_name + current_customer.first_name
#     when "registered_address" # 配送先登録済みの住所に配送
#       unless params[:order][:registered_address_id] == ""
#         selected = Address.find(params[:order][:registered_address_id])
#         @selected_address = selected.post_code + " " + selected.address
#         @selected_name = selected.name
#       else
#         render :new
#       end
#     when "new_address" #新たな配送先住所に配送
#       unless params[:order][:new_post_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
#         @selected_address = params[:order][:new_post_code] + " " + params[:order][:new_address]
#         @selected_name = params[:order][:new_name]
#       else
#         render :new
#       end
#     end

#     # クーポン適用
#     @order = current_customer.orders.new(order_params)
#     coupon = Coupon.find_by(code: params[:order][:coupon_code])

#     if coupon && coupon.available_for?(current_customer, @order.total_price)
#       @order.total_price -= coupon.discount_price
#     end

#     if @order.save
#       # クーポン使用履歴を保存
#       if coupon && coupon.available_for?(current_customer, @order.total_price + coupon.discount_price)
#         CouponUsage.create!(customer: current_customer, coupon: coupon, used_at: Time.current)
#       end

#       redirect_to order_complete_path, notice: "注文が完了しました"
#     else
#       flash.now[:alert] = "注文に失敗しました"
#       render :new
#     end    
#   end

#   def create # 注文情報入力画面(支払方法・配送先の選択)/注文確定処理
#     @customer = current_customer
#     @order = Order.new
#     @order.customer_id = current_customer.id
#     @order.shipping_fee = 800
#     @cart_items = CartItem.where(customer_id: current_customer.id)

#     ary = []
#       @cart_items.each do |cart_item|
#         ary << cart_item.item.price_excluding_tax*cart_item.amount
#       end
#       @cart_items_price = ary.sum
#       @order.total_price = @order.shipping_fee + @cart_items_price

#     @order.payment_method = params[:order][:payment_method].presence || "credit_card"
#     if @order.payment_method == "credit_card"
#       @order.status = 0
#     else
#       @order.status = 0
#     end

#     address_type = params[:order][:address_type]
#     case address_type
#     when "customer_address"
#       @order.post_code = current_customer.post_code
#       @order.address = current_customer.address
#       @order.name = current_customer.last_name + current_customer.first_name
#     when "registered_address"
#       Address.find(params[:order][:registered_address_id])
#       selected = Address.find(params[:order][:registered_address_id])
#       @order.post_code = selected.post_code
#       @order.address = selected.address
#       @order.name = selected.name
#     when "new_address"
#       @order.post_code = params[:order][:new_post_code]
#       @order.address = params[:order][:new_address]
#       @order.name = params[:order][:new_name]
#     end

#     if @order.save
#       session[:order_id] = @order.id # OrderのIDをセッションに保存
#       if @order.status == 0
#         @cart_items.each do |cart_item|
#           OrderDetail.create!(order_id: @order.reload.id, item_id: cart_item.item.id, purchase_price: (cart_item.item.price_excluding_tax*1.1).floor, quantity: cart_item.amount, status: 0)
#         end
#       else
#         @cart_items.each do |cart_item|
#           OrderDetail.create!(order_id: @order.reload.id, item_id: cart_item.item.id, purchase_price: (cart_item.item.price_excluding_tax*1.1).floor, quantity: cart_item.amount, status: 0)
#         end
#       end
#       @cart_items.destroy_all
#       redirect_to thanks_orders_path
#     else
#       render :items
#     end
#   end

#   def index # 注文履歴画面
#     @customer = current_customer
#     @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
#     @orders.each do |order|
#       order_details = OrderDetail.where(order_id: order.id)
#       shipping_fee = order.shipping_fee.to_i
#       cart_items_price = order_details.sum { |detail| detail.purchase_price.to_i * detail.quantity.to_i }
#       order.total_price = shipping_fee + cart_items_price  # 合計金額を計算
#     end
#   end

#   def show # 注文履歴詳細画面
#     @customer = current_customer
#     @order = Order.find(params[:id])
#     @order_details = OrderDetail.where(order_id: @order.id)
#     @shipping_fee = @order.shipping_fee.to_i
#     @cart_items_price = @order_details.sum { |detail| detail.purchase_price.to_i * detail.quantity.to_i }
#     @total_price = @shipping_fee + @cart_items_price
#   end

#   def thanks # 注文完了画面
#     @customer = current_customer
#   end

#   private

#   def order_params
#     params.require(:order).permit(:shipping_address, :payment_method, :total_price)
#   end

# end

