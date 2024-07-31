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
      patch :update
    end
    resources :suggestions, only: %i[create update destroy edit] do
      member do
        post :reply
        patch :update
      end
    end
    resources :comments do
      resources :reports, only: %i[create destroy]
      resources :likes, only: %i[create destroy], defaults: { likeable_type: 'Comment' }
      collection do
        get :reported, to: 'comments#index', reported: true
        delete :unreport, to: 'comments#destroy'
      end
      member do
        delete :unpublish, to: 'comments#destroy', unpublish: true
      end
    end
  end

  # Custom Comment Routes
  patch '/posts/:post_id/comments/:id/report', to: 'comments#report_comment', as: 'report_comment'
  delete '/unlike/:likeable_id', to: 'likes#destroy', as: 'unlike'
  post '/like/:likeable_id', to: 'likes#create', as: 'like'

  # Custom reported comments route
  get 'reported_comments', to: 'comments#index', as: 'reported_comments', reported: true

  # Moderator Dashboard routes
  resources :moderator_dashboard
  patch '/moderator_dashboard/:id', to: 'moderator_dashboard#update', as: 'update_post'
end
