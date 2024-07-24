Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  get '/users/sign_out' => 'devise/sessions#destroy'

  root 'dashboard#index'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'

  resources :users, only: %i[show edit update]
  resources :posts do
    resources :comments, only: %i[create edit update destroy]
    member do
      get :like
      put :like
      delete :unlike
    end
  end

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
end
