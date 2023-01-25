Rails.application.routes.draw do
  get "dashboard", to: "user#dashboard"
  get "portfolio", to: "user#portfolio", as: "portfolio"

  get "stocks/turbo/:id", to: "stocks#turbo_show", as: "stock_turbo_show"
  get "stocks", to: "stocks#index", as: "stocks"
  get "stocks/:id", to: "stocks#show", as: "stock_details"
  post "orders/buy/:stock_id", to: "orders#buy", as: "buy_order"
  post "orders/sell/:stock_id", to: "orders#sell", as: "sell_order"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_scope :user do
        authenticated :user do
        root :to => 'user#dashboard', as: :authenticated_root
      end
      unauthenticated :user do
        root :to => 'devise/sessions#new', as: :unauthenticated_root
      end
  end

  root "devise/sessions#new"
  get "error", to: "pages#error"
  get "admin", to: "admin#dashboard"
  get "admin/manage/:id", to: "admin#show", as: "show_user"
  get "admin/manage/:id/edit", to: "admin#edit", as: "edit_user"
  patch "admin/manage/:id", to: "admin#update", as: "update_user"
  delete "admin/manage/:id", to: "admin#destroy", as: "destroy_user"
  patch "admin/manage/:id/approve", to: "admin#approve", as: "approve_user"
  post 'deposit', to: 'user#deposit'
  post 'withdraw', to: 'user#withdraw'
  get "admin/transactions", to: "admin#transactions", as: "admin_transactions"
  get "orders", to: "orders#index", as: "orders"
  patch "orders/:id/cancel/:stock_id", to: "orders#cancel", as: "cancel_order"
end
