Rails.application.routes.draw do
  # resources :stocks do
  #   resources :orders
  # end
  get "stocks", to: "stocks#index", as: "stocks"
  get "stocks/:id", to: "stocks#show", as: "stock_details"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }


  devise_scope :user do
        authenticated :user do
        root :to => 'stocks#index', as: :authenticated_root
      end
      unauthenticated :user do
        root :to => 'devise/sessions#new', as: :unauthenticated_root
      end
  end

  root "pages#landing"
  get "error", to: "pages#error"
  get "admin", to: "admin#dashboard"
  get "admin/manage/:id", to: "admin#show", as: "show_user"
  get "admin/manage/:id/edit", to: "admin#edit", as: "edit_user"
  patch "admin/manage/:id", to: "admin#update", as: "update_user"
  delete "admin/manage/:id", to: "admin#destroy", as: "destroy_user"
  patch "admin/manage/:id/approve", to: "admin#approve", as: "approve_user"
end
