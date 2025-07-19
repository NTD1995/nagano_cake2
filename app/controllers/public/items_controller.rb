class Public::ItemsController < ApplicationController
  def index
    @customer = current_customer
    @items = Item.where(is_sale: true).page(params[:page]).per(8)
    @total_item_count = Item.where(is_sale: true).count
    if current_customer
      @cart_items = CartItem.where(customer_id: current_customer.id)
    else
      @cart_items = []
    end
  end

  def show
    @customer = current_customer
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end  
end
