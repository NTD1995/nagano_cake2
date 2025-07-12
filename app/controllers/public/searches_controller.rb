class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!
  
  # 検索処理
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    
    if @model  == "customer"
      @records = Customer.search_for(@content, @method)
    else
      @records = Item.search_for(@content, @method)
    end
    @records = @records.page(params[:page]).per(1)
  end   

end
