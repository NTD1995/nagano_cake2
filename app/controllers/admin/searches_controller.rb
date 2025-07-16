class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    keyword = params[:keyword]
    target = params[:target]
    match_type = params[:match_type]

    case target
    when "item"
      @items = Item.where("name LIKE ?", match_keyword(keyword, match_type)).page(params[:page])
    when "customer"
      @customers = Customer.where("last_name LIKE ? OR first_name LIKE ?", *[match_keyword(keyword, match_type)]*2).page(params[:page])
    end
  end

  private

  def match_keyword(keyword, match_type)
    case match_type
    when "exact"
      keyword
    when "partial"
      "%#{keyword}%"
    when "forward"
      "#{keyword}%"
    when "backward"
      "%#{keyword}"
    else
      "%#{keyword}%"
    end
  end
end
