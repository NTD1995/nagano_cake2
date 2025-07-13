class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!
  
  # 検索処理
  def search
    @keyword = params[:keyword]
    @target = params[:target] 
    @match_type = params[:match_type] 

    @results = case @target
               when 'item'
                 Item.search(@keyword, @match_type)
               when 'customer'
                 Customer.search(@keyword, @match_type)
               else
                 []
               end
  end  

end  

