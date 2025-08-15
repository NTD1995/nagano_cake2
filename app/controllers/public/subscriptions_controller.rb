class Public::SubscriptionsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @subscriptions = current_customer.subscriptions
  end

  def new
    @item = Item.find(params[:item_id])
    @subscription = current_customer.subscriptions.new(item: @item)
  end

  def create
    @item = Item.find(params[:item_id])
    @subscription = current_customer.subscriptions.new(subscription_params)
    @subscription.item = @item
    @subscription.interval_days = @subscription.interval_days.to_i
    @subscription.next_delivery_date = Date.today + @subscription.interval_days.days

    if @subscription.save
      redirect_to item_subscriptions_path(@item), notice: "定期購入を開始しました"
    else
      render :new
    end
  end

  def edit
    @subscription = current_customer.subscriptions.find(params[:id])
  end

  def update
    @subscription = current_customer.subscriptions.find(params[:id])
    if @subscription.update(subscription_params)
      redirect_to subscriptions_path, notice: "定期購入を更新しました"
    else
      render :edit
    end
  end

  def cancel
    @subscription = current_customer.subscriptions.find(params[:id])
    @subscription.update(status: "canceled")
    redirect_to subscriptions_path, notice: "定期購入を解約しました"
  end

  private

  def subscription_params
    params.require(:subscription).permit(:item_id, :quantity, :interval_days)
  end
end
