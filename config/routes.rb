Rails.application.routes.draw do
  # トップページ
  root to: "public/homes#top"
  # アバウトページ
  get "/about", to: "public/homes#about", as: "about"
  # 管理者のログイン
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 管理者トップページ 
  get "/admin", to: "admin/homes#top", as: "admin/top"

  namespace :admin do
      # 商品
    resources :items
    # ジャンル
    resources :genres, only: [:index, :create, :edit, :update, :destroy]
    # 会員
    resources :customers,     only: [:index, :show, :edit, :update] 
    # 注文 
    resources :orders,        only: [:show, :update] do
    # 注文更新
    resources :orders_details, only: [:update]
    end
    # 検索一覧 
    get "search", to: "searches#search", as: "search"   
    # クーポン
    resources :coupons  
    # 再通知一覧
    resources :notifications, only: [:index, :update]   
  end

  # 会員のログイン、新規登録
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  } 

  #会員情報
  get '/customers/my_page', to: 'public/customers#show'
  get '/customers/information/edit', to: 'public/customers#edit'
  patch '/customers/information', to: 'public/customers#update'
  get '/customers/unsubscribe', to: 'public/customers#unsubscribe'
  patch '/customers/withdraw', to: 'public/customers#withdraw'  
  get 'customers/favorites', to: 'customers#favorites', as: 'customer_favorites'
  
  # 商品
  resources :items, controller: 'public/items', only: [:index, :show] do
    # お気に入り
    resource :favorite, only: [:create, :destroy], controller: 'public/favorites', as: :favorite
    # レビュー
    resources :reviews, only: [:create, :destroy], controller: 'public/reviews' 
    # ランキング
    collection do
      get :ranking
    end
    # 再入荷通知希望
    resource :restock_requests, only: [:create, :destroy], controller: 'public/restock_requests', as: 'restock_request'   
  end
  
  # 注文
  resources :orders, controller: 'public/orders', only:[:new, :create, :index, :show] do
    collection do
      # 注文情報確認
      post 'confirm'
      # 注文感謝
      get 'thanks'
      # クーポン適用
      post 'apply_coupon'      
    end
  end
  
  # カート内商品
  resources :cart_items, controller: 'public/cart_items', only: [:index, :create, :update, :destroy] do
    collection do
      delete :destroy_all
    end
  end

  # 配送先
  resources :addresses, controller: 'public/addresses', only: [:index, :create, :edit, :update, :destroy]
  
  # 検索一覧
  get "search", to: "public/searches#search", as: "public_search"
    
  # 商品比較
  resources :comparisons, controller: 'public/comparisons', only: [:index, :create]
  delete 'comparisons/:item_id', to: 'public/comparisons#destroy', as: 'remove_comparison'

  # 通知
  resources :notifications, only: [:index, :update], controller: 'public/notifications'


end
