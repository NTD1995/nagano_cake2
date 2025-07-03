class Admin::OrdersDetailsController < ApplicationController
  before_action :authenticate_admin!

  def update
    @order_detail_update_target = OrderDetail.find(params[:id])
    order_details_index = OrderDetail.where(order_id: params[:order_id])

    if @order_detail_update_target.update(order_detail_params)
      # 製作ステータスに応じて、注文ステータスを更新
      all_comp_flg = 0

      if params[:order_detail][:status] == "done_production"
        order_details_index.each do |order_detail|
          i = OrderDetail.find(order_detail.id)
          if i.status != "done_production"
            all_comp_flg = 1
            break
          end
        end

        if all_comp_flg == 0
          comped_order = Order.find(params[:order_id])
          comped_order.update_attribute(:status, "in_shipping")
        end
      else
        order_details_index.each do |order_detail|
          i = OrderDetail.find(order_detail.id)
          relate_order = Order.find(i.order_id)
          if i.status == "in_production"
            relate_order.update_attribute(:status, "in_production")
            break
          end
        end
      end
      redirect_to request.referer, notice: "製作ステータスを更新しました"
    else
      render :show
    end

  end

  private
    def order_detail_params
      params.require(:order_detail).permit(:status)
    end

end
