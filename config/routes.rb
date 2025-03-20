Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "help", to: "static_pages#help"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "signup", to: "users#new", as: "sign_up"
    post "signup", to: "users#create"
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :users, only: [:show, :edit, :index, :update, :destroy]
    resources :account_activations, only: [:edit]
    resources :microposts, only: [:create, :destroy]
  end
end
