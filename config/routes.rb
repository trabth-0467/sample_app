Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "help", to: "static_pages#help"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "signup", to: "users#new"
    post "signup", to: "users#create"
    resources :users, only: [:show, :edit, :index, :update, :destroy]
  end
end
