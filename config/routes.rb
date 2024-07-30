# frozen_string_literal: true

Rails.application.routes.draw do
  # Admin routes
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'

  # Devise routes
  devise_for :users
  get '/users/sign_out' => 'devise/sessions#destroy'

  # Dashboard routes
  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/moderator_dashboard', to: 'moderator_dashboard#index', as: 'moderator_dashboard'

  # Users routes
  resources :users, only: %i[show edit update]

  # Posts routes
  resources :posts do
    collection do
      get :pending_approval
      get :reported, action: :reported_posts
    end
    member do
      patch :approve
      patch :reject
      patch :unpublish
      get :report
      patch :unreport
      post :toggle_like
    end
    resources :suggestions, only: %i[create update destroy edit] do
      member do
        post :reply
        patch :reject
      end
    end
    resources :comments do
      member do
        get :report, action: :report_comment
        patch :report, action: :report_comment
        patch :unreport, action: :unreport_comment
        patch :unpublish
        post :like
        delete :unlike
      end
    end
  end

  # Custom Comment Routes
  patch '/posts/:post_id/comments/:id/report', to: 'comments#report_comment', as: 'report_comment'
  get '/reported_comments', to: 'comments#reported_comments', as: 'reported_comments'
  get '/comments/:id/unreport', to: 'comments#unreport_comment', as: 'unreport_comment'

  # Moderator Dashboard routes
  resources :moderator_dashboard, only: [:index]
end
