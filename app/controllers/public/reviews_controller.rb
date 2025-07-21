class Public::ReviewsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @item = Item.find(params[:item_id])
    @review = @item.reviews.new(review_params)
    @review.customer = current_customer

    if @review.save
      redirect_to item_path(@item), notice: "レビューを投稿しました。"
    else
      @reviews = @item.reviews.order(created_at: :desc)
      render 'public/items/show'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.customer == current_customer
      @review.destroy
      redirect_to item_path(@review.item), notice: "レビューを削除しました。"
    else
      redirect_to item_path(@review.item), alert: "自分のレビューのみ削除できます。"
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

end
