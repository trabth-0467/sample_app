Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "help", to: "static_pages#help"
    get "login", to: "sessions#new"
  end
end
