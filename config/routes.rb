Rails.application.routes.draw do
  # Mount RailsAdmin at /admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Devise routes for user authentication
  devise_for :users


  # RESTful routes for users with only specified actions
  resources :users, only: [:show, :edit, :update, :destroy]

  # RESTful routes for posts with nested routes for comments
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
    post 'like', to: 'likes#create', as: 'like'
    delete 'like', to: 'likes#destroy', as: 'unlike'
  end

  # Custom route for the moderator dashboard
  get 'moderator_dashboard', to: 'moderators#dashboard'

  # Optionally, set a root path for your application
  # root to: 'home#index'
end
