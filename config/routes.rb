# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  get '/users/sign_out' => 'devise/sessions#destroy'
  get '/moderator_dashboard', to: 'moderator_dashboard#index', as: 'moderator_dashboard'

  root 'dashboard#index'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'

  get 'posts/pending_approval', to: 'posts#pending_approval'
  get 'posts/reported', to: 'posts#reported_posts', as: 'reported_posts'
  patch 'posts/:id/unreport', to: 'posts#unreport', as: 'unreport_post'
  patch '/posts/:id/report', to: 'posts#report', as: 'report_post'
  patch '/posts/:id/unpublish', to: 'posts#unpublish', as: 'unpublish_post'
  post '/posts/:id/like', to: 'posts#like', as: 'like_post'
  patch '/comments/:id/like', to: 'comments#like', as: 'like_comment'
  patch '/comments/:id/unlike', to: 'comments#unlike', as: 'unlike_comment'
  patch '/comments/:id/report', to: 'comments#report_comment', as: 'report_comment'
  get '/reported_comments', to: 'comments#reported_comments', as: 'reported_comments'
  patch '/comments/:id/unreport', to: 'comments#unreport_comment', as: 'unreport_comment'
  patch '/comments/:id/unpublish', to: 'comments#unpublish_comment', as: 'unpublish_comment'

  # get '/posts/:post_id/comments', to: 'comments#index', as: 'post_comments'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  resources :users, only: %i[show edit update]
  resources :moderator_dashboard

  resources :posts do
    get :pending_approval, on: :collection
    get :moderate_reported_posts, on: :collection
    resources :suggestions, only: %i[create update destroy edit] do
      member do
        post :reply
        patch :reject
      end
    end

    member do
      patch :approve
      patch :reject
      patch :report
      patch :unreport
      delete :destroy
      get :like
      put :like
      delete :unlike
      patch :unlike
    end

    resources :comments, only: %i[create edit update destroy show new] do
      member do
        patch :report
        patch :unreport
        get :like
        delete :unlike
        patch :unlike
        get :like, as: 'like_comment'
      end
    end
    collection do
      get :index
      get :reported
    end
  end

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
end
