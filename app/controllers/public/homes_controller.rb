class Public::HomesController < ApplicationController
  def top
    @items = Item.where(is_sale: true)
    @items_new = @items.order(created_at: :desc).limit(4)
    @customer = current_customer  
  end

  def about
  end  
end
