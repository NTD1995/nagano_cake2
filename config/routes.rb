Rails.application.routes.draw do
  devise_for :admins
  devise_for :customers
  root to: "public/homes#top"
  get "/about", to: "public/homes#about", as: "about"
end
