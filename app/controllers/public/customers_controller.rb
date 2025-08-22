class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, except: [:new, :create]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to customers_my_page_path, notice: "会員情報を更新しました。"
    else
      flash.now[:alert] = "会員情報を更新できません。"
      render :edit
    end
  end

  def unsubscribe
    @customer = current_customer
  end

  def withdraw
    @customer = current_customer
    @customer.update(is_active: false)
    sign_out(@customer)
    redirect_to root_path
  end

  def favorites
    @favorite_items = current_customer.favorite_items
  end


  private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :post_code, :address, :phone_number, :email, :is_active)
  end

  # ゲストユーザーがプロフィールを編集できないようにする  
  def ensure_guest_user
    if current_customer.email == "guest@guest"
      redirect_to customers_mypage_path, alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
