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

  # 商品
  namespace :admin do
    resources :items
    resources :genres, only: [:index, :create, :edit, :update, :destroy]
    resources :customers,     only: [:index, :show, :edit, :update]      
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
end
