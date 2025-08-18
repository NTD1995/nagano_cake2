class Admin::SubscriptionsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @subscriptions = Subscription.includes(:customer, :item).order(created_at: :desc)
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def edit
    @subscription = Subscription.find(params[:id])
  end

  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update(subscription_params)
      redirect_to admin_subscriptions_path, notice: "定期購入情報を更新しました。"
    else
      render :show
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to admin_subscriptions_path, notice: "定期購入を削除しました。"
  end

  private

  def subscription_params
    params.require(:subscription).permit(:quantity, :interval_days, :status, :next_delivery_date)
  end
end