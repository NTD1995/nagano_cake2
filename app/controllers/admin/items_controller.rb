class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items = Item.all.includes(:genre).page(params[:page])
  end

  def show
    @item = Item.find(params[:id])
    @tax_included_price = (@item.price_excluding_tax * 1.1).floor
  end

  def new
    @item = Item.new
    @genres = Genre.all
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item), notice: "商品を登録しました"
    else
      @genres = Genre.all
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
    @genres = Genre.all
  end

  def update
    @item = Item.find(params[:id])
    old_stock = @item.stock

    if @item.update(item_params)
      if old_stock == 0 && @item.stock > 0
        notify_restock(@item)
      end
      redirect_to admin_item_path(@item), notice: "商品情報を更新しました"
    else
      @genres = Genre.all
      flash[:alert] = "商品情報を更新できませんでした。"
      render :edit
    end
  end  

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path, notice: "商品を削除しました"
  end

  private

  def item_params
    params.require(:item).permit(:genre_id, :name, :introduction, :price_excluding_tax, :is_sale, :image, :stock)
  end

  def notify_restock(item)
    restock_requests = RestockRequest.where(item_id: item.id, notified: false)

    restock_requests.each do |request|
      Notification.create!(
        customer_id: request.customer_id,
        item_id: item.id,
        message: "#{item.name}が再入荷されました！",
        read: false
      )

      request.update!(notified: true)
    end
  end

end
