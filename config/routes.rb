Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  get '/users/sign_out' => 'devise/sessions#destroy'
  get '/moderator_dashboard', to: 'moderator_dashboard#index', as: 'moderator_dashboard'

  root 'dashboard#index'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  resources :users, only: %i[show edit update]
  resources :moderator_dashboard
  resources :posts do
    get :pending_approval, on: :collection
    member do
      patch :approve
      patch :reject
    end
    resources :comments, only: %i[create edit update destroy]
    member do
      get :like
      put :like
      delete :unlike
    end
  end

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
end
