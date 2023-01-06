Rails.application.routes.draw do
  resources :stocks do
    resources :orders
  end
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  root "pages#landing"
  get "error", to: "pages#error"
  get "admin", to: "admin#dashboard"
  get "admin/:id", to: "admin#show", as: "show_user"
  # get "admin/:id/edit", to: "admin#edit", as: "edit_user"
  devise_scope :user do
    get "admin/:id/edit", to: "users/registrations#edit", as: "edit_user"
  end
  patch "admin/:id", to: "admin#update", as: "update_user"
  delete "admin/:id", to: "admin#destroy", as: "destroy_user"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
