Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "home_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    resources :books
    namespace :admin do
      root "admin#index"
    end
  end
end
