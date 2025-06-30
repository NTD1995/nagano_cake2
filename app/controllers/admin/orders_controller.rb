class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def show
    @order_update_target = Order.find(params[:id])
    @order_details_index = OrderDetail.where(order_id: params[:id])
  end

  def update
    @order_update_target = Order.find(params[:id])
    @order_details_index = OrderDetail.where(order_id: params[:id])

    if @order_update_target.update(order_params)
      # 注文ステータスに応じて、製作ステータスを更新
      if params[:order][:status] == "confirm_payment"
        @order_details_index.each do |order_detail|
          i = OrderDetail.find(order_detail.id)
          i.update_attribute(:status, "wait_production")
        end
      end
      redirect_to request.referer, notice: "注文ステータスを更新しました"
    else
      render :show
    end
  end

  private
    def order_params
      params.require(:order).permit(:status)
    end

end
