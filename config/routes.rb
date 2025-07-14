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

  # 商品
  resources :items, controller: 'public/items', only: [:index, :show]  
  
  # 注文
  resources :orders, controller: 'public/orders', only:[:new, :create, :index, :show] do
    collection do
      post 'confirm'
      get 'thanks'
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
  get "search", to: "public/searches#search", as: "search"
    
end
