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
    @review = Review.new
    @reviews = @item.reviews.order(created_at: :desc)  
    @subscription = current_customer.subscriptions.new(item: @item) 
    if customer_signed_in?
      @view_history = ViewHistory.find_or_initialize_by(customer_id: current_customer.id, item_id: @item.id)
      if @view_history.new_record?
        @view_history.save 
      else
        @view_history.touch
      end  
    end
    @recommend_items = recommended_items(@item)         
    end

    def ranking
      @ranked_items = Item
        .joins(:order_details)
        .group(:id)
        .select('items.*, SUM(order_details.quantity) as total_orders')
        .order('total_orders DESC')
        .limit(10)
    end    
    
  private

  # 閲覧履歴に基づくおすすめ商品
  def recommended_items(item)
    # この商品を見た他ユーザーが見ている商品一覧（重複なし・自分が見た商品除外）
    customer_ids = item.view_histories.pluck(:customer_id)
    item_ids = ViewHistory.where(customer_id: customer_ids).where.not(item_id: item.id).pluck(:item_id)
    Item.where(id: item_ids.uniq).limit(5)
  end    
end
