class ApplicationController < ActionController::Base
  before_action :set_current_customer

  private

  def set_current_customer
    if customer_signed_in?
      @customer = current_customer
    end
  end  
end
