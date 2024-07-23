Rails.application.routes.draw do
  # Mount RailsAdmin at /admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Devise routes for user authentication
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root 'dashboard#index'
  # RESTful routes for users with only specified actions
  resources :users, only: %i[show edit update]

  # RESTful routes for posts with nested routes for comments
  resources :posts do
    resources :comments, only: %i[create edit update destroy]
    post 'like', to: 'likes#create', as: 'like'
    delete 'like', to: 'likes#destroy', as: 'unlike'
  end

  # Custom route for the dashboard
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  # Optionally, set a root path for your application
  # root to: 'home#index'
end
