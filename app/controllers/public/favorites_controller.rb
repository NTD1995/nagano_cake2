class Public::FavoritesController < ApplicationController
    before_action :authenticate_customer!

    def create
      item = Item.find(params[:item_id])
      current_customer.favorites.create(item: item)
      redirect_back fallback_location: items_path, notice: "お気に入りに登録しました"
    end

    def destroy
      item = Item.find(params[:item_id])
      favorite = current_customer.favorites.find_by(item_id: item.id)
      favorite.destroy if favorite
      redirect_back fallback_location: items_path, notice: "お気に入りを解除しました"
    end
end
