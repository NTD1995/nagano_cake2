Rails.application.routes.draw do
  namespace :admin do
    get 'genres/index'
    get 'genres/create'
    get 'genres/edit'
    get 'genres/update'
    get 'genres/destroy'
  end
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
  end

  # 会員のログイン、新規登録
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  } 

  # 商品
  resources :items, controller: 'public/items', only: [:index, :show]   
end
