class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @addresses = Address.all
    @customer = current_customer
  end

  def create
    @customer = current_customer
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to addresses_path
    else
      @addresses = current_customer.addresses
      render :index
    end
  end

  def edit
    @address = Address.find(params[:id])
    @customer = current_customer
  end

  def update
    @address = Address.find(params[:id])
    @address.customer_id = current_customer.id
    if @address.update(address_params)
      redirect_to addresses_path
    else
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path, notice: "配送先一覧から配送先を削除しました"
  end

  private
   def address_params
    params.require(:address).permit(:post_code, :address, :name)
   end

end
