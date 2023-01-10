Rails.application.routes.draw do
  resources :stocks do
    resources :orders
  end
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  get "error", to: "pages#error"
  get "admin", to: "admin#dashboard"
  get "admin/manage/:id", to: "admin#show", as: "show_user"
  # get "admin/:id/edit", to: "admin#edit", as: "edit_user"
  devise_scope :user do
    get "admin/manage/:id/edit", to: "users/registrations#edit", as: "edit_user"
        authenticated :user do
        root :to => 'stocks#index', as: :authenticated_root
      end
      unauthenticated :user do
        root :to => 'devise/sessions#new', as: :unauthenticated_root
      end
  end
  patch "admin/manage/:id", to: "admin#update", as: "update_user"
  delete "admin/manage/:id", to: "admin#destroy", as: "destroy_user"
  patch "admin/manage/:id/approve", to: "admin#approve", as: "approve_user"
  get "admin/users/:id", to: "admin#user_row", as: "user_row"
end
