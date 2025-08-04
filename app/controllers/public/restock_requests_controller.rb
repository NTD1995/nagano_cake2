class Public::RestockRequestsController < ApplicationController
  before_action :authenticate_customer!

  def create
    item = Item.find(params[:item_id])
    current_customer.restock_requests.find_or_create_by(item: item)
    redirect_to item_path(item), notice: "再入荷通知を希望しました"
  end

  def destroy
    item = Item.find(params[:item_id])
    request = current_customer.restock_requests.find_by(item_id: item.id)
    request&.destroy
    redirect_to item_path(item), notice: "通知を解除しました"
  end  
end