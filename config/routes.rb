Rails.application.routes.draw do
  root to: "public/homes#top"
  get "/about", to: "public/homes#about", as: "about"
end
