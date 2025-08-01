class Public::ComparisonsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @compared_items = current_customer.compared_items
  end

  def create
    item = Item.find(params[:item_id])
    current_customer.comparisons.find_or_create_by(item: item)
    redirect_to items_path, notice: "比較リストに追加しました"
  end

  def destroy
    comparison = current_customer.comparisons.find_by(item_id: params[:item_id])
    comparison.destroy if comparison
    redirect_to comparisons_path, notice: "比較リストから削除しました"
  end
end
