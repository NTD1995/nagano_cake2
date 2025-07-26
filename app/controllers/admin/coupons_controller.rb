class Admin::CouponsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_coupon, only: [:edit, :update, :destroy]

  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to admin_coupons_path, notice: "クーポンを作成しました"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @coupon.update(coupon_params)
      redirect_to admin_coupons_path, notice: "クーポンを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @coupon.destroy
    redirect_to admin_coupons_path, notice: "クーポンを削除しました"
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:code, :discount_price, :minimum_order_amount, :is_active)
  end
end
