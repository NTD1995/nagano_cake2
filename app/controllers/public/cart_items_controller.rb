class Public::CartItemsController < ApplicationController
 before_action :authenticate_customer!
  def index
    @customer = current_customer
    @cart_items = current_customer.cart_items.includes(:item)
    @total_price = @cart_items.sum { |cart_item| cart_item.item.price_excluding_tax * cart_item.amount * 1.1 }
  end

  def update
    cart_item = CartItem.find(params[:id])
    if cart_item.update(amount: params[:cart_item][:amount])
      redirect_to cart_items_path
    else
      redirect_to cart_items_path
    end
  end

  def destroy
   cart_item = CartItem.find(params[:id])
   cart_item.destroy
   redirect_to cart_items_path, notice: "カートから商品を削除しました"
  end

  def destroy_all
   current_customer.cart_items.destroy_all
   redirect_to cart_items_path, notice: "カートを空にしました"
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id=current_customer.id
    @cart_items=current_customer.cart_items.all
    @cart_items.each do |cart_item|
      if cart_item.item_id == @cart_item.item_id
        new_amount = cart_item.amount + @cart_item.amount
        cart_item.update_attribute(:amount, new_amount)
        @cart_item.delete

        redirect_to cart_items_path, notice:"カートに追加しました"
        return

      end
    end
    if @cart_item.save
      redirect_to cart_items_path, notice:"カートに追加しました"
    else
      flash[:alert] = "カートに商品を追加できませんでした。"
      redirect_to request.referer
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end

end
