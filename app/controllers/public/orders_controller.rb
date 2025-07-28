class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new # 注文情報入力画面(支払方法・配送先の選択)/注文確定処理
    @customer = current_customer
    @order = Order.new
  end

  def confirm # 注文情報確認画面
    @customer = current_customer
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @shipping_fee = 800
    @selected_payment_method = params[:order][:payment_method]

    # 商品合計額の計算
    ary = []
    @cart_items.each do |cart_item|
      ary << (cart_item.item.price_excluding_tax * 1.1).floor * cart_item.amount
    end
    @cart_items_price = ary.sum # 商品の小計
    @total_price = @shipping_fee + @cart_items_price # 商品の小計+送料

      # クーポン処理
      coupon = Coupon.find_by(code: params[:order][:coupon_code])

      # 商品合計額（送料含む）に基づいてクーポン適用確認
      if coupon && coupon.available_for?(current_customer, @total_price)
        @discount_price = coupon.discount_price
        @total_price -= @discount_price
        @applied_coupon = coupon
      else
        @discount_price = 0
      end

    # 配送先の指定
    @address_type = params[:order][:address_type]
    case @address_type
    when "customer_address" # 会員登録の住所に配送
      @selected_address = current_customer.post_code + " " + current_customer.address + " "
      @selected_name = current_customer.last_name + current_customer.first_name
    when "registered_address" # 配送先登録済みの住所に配送
      unless params[:order][:registered_address_id] == ""
        selected = Address.find(params[:order][:registered_address_id])
        @selected_address = selected.post_code + " " + selected.address
        @selected_name = selected.name
      else
        render :new
      end
    when "new_address" #新たな配送先住所に配送
      unless params[:order][:new_post_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
        @selected_address = params[:order][:new_post_code] + " " + params[:order][:new_address]
        @selected_name = params[:order][:new_name]
      else
        render :new
      end
    end  
  end
  
  def create # 注文情報入力画面(支払方法・配送先の選択)/注文確定処理
    @customer = current_customer
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.shipping_fee = 800
    @cart_items = CartItem.where(customer_id: current_customer.id)

    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.price_excluding_tax*cart_item.amount
    end
    @cart_items_price = ary.sum
    @order.total_price = @order.shipping_fee + @cart_items_price

    # 小計
    cart_total = @cart_items.sum do |item|
      (item.item.price_excluding_tax * 1.1).floor * item.amount
    end
    # クーポン適用
    coupon = Coupon.find_by(code: params[:order][:coupon_code])

    if coupon && coupon.available_for?(current_customer, cart_total)
      @order.total_price = cart_total - coupon.discount_price
    else
      @order.discount_price = 0
      @order.total_price = cart_total
      coupon = nil
    end      

    @order.payment_method = params[:order][:payment_method].presence || "credit_card"
    if @order.payment_method == "credit_card"
      @order.status = 0
    else
      @order.status = 0
    end

    address_type = params[:order][:address_type]
    case address_type
    when "customer_address"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    when "registered_address"
      Address.find(params[:order][:registered_address_id])
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
      session[:order_id] = @order.id # OrderのIDをセッションに保存
      if @order.status == 0
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.reload.id, item_id: cart_item.item.id, purchase_price: (cart_item.item.price_excluding_tax*1.1).floor, quantity: cart_item.amount, status: 0)
        end
      else
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.reload.id, item_id: cart_item.item.id, purchase_price: (cart_item.item.price_excluding_tax*1.1).floor, quantity: cart_item.amount, status: 0)
        end
      end
      @cart_items.destroy_all
      # クーポン使用履歴保存
      if coupon
          CouponUsage.create!(customer: current_customer, coupon: coupon, used_at: Time.current)
        redirect_to thanks_orders_path
      else
        render :new
      end
    end
  end


  def index # 注文履歴画面
    @customer = current_customer
    @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
    @orders.each do |order|
      order_details = OrderDetail.where(order_id: order.id)
      shipping_fee = order.shipping_fee.to_i
      cart_items_price = order_details.sum { |detail| detail.purchase_price.to_i * detail.quantity.to_i }
      discount = order.discount_price.to_i || 0
      order.total_price = shipping_fee + cart_items_price - discount # 合計金額を計算
    end  
  end


  def show # 注文履歴詳細画面
    @customer = current_customer
    @order = Order.find(params[:id])
    @order_details = @order.order_details    
    @shipping_fee = @order.shipping_fee.to_i
    @cart_items_price = @order_details.sum { |detail| detail.purchase_price.to_i * detail.quantity.to_i }
    @discount_price = @order.discount_price.to_i || 0
    @total_price = @shipping_fee + @cart_items_price - @discount_price
  end

  def thanks # 注文完了画面
    @customer = current_customer
  end

  private

  def order_params
    params.require(:order).permit(
      :payment_method,
      :shipping_address,
      :total_price
    )
  end
end

