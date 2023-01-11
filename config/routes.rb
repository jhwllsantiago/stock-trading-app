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
  get "admin/manage/:id", to: "admin#show", as: "show_user"
  get "admin/manage/:id/edit", to: "admin#edit", as: "edit_user"
  patch "admin/manage/:id", to: "admin#update", as: "update_user"
  delete "admin/manage/:id", to: "admin#destroy", as: "destroy_user"
  patch "admin/manage/:id/approve", to: "admin#approve", as: "approve_user"
end
