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
    resources :likes, only: %i[create destroy], defaults: { likeable_type: 'Post' }
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
    end
    resources :suggestions, only: %i[create update destroy edit] do
      member do
        post :reply
        patch :reject
      end
    end
    resources :comments do
      resources :likes, only: %i[create destroy], defaults: { likeable_type: 'Comment' }
      member do
        get :report, action: :report_comment
        patch :report, action: :report_comment
        patch :unreport, action: :unreport_comment
        patch :unpublish
      end
    end
  end

  # Custom Comment Routes
  patch '/posts/:post_id/comments/:id/report', to: 'comments#report_comment', as: 'report_comment'
  get '/reported_comments', to: 'comments#reported_comments', as: 'reported_comments'
  delete '/unlike/:likeable_id', to: 'likes#destroy', as: 'unlike' # Moderator Dashboard routes
  post '/like/:likeable_id', to: 'likes#create', as: 'like'

  resources :moderator_dashboard, only: [:index]
end
