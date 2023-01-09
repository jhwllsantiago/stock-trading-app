Rails.application.routes.draw do
  resources :stocks do
    resources :orders

    
  end
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
    

  }
  
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  
  get "error", to: "pages#error"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'devise/sessions#new'
end
