class DashboardController < ApplicationController
  include CacheControlConcern

  before_action :authenticate_user!
  before_action :set_cache_control

  def index
    @posts = Post.all
    @comments = Comment.all
    @likes = Like.all
    @recent_posts = Post.all.order(created_at: :desc).limit(2)
    @recent_comments = Comment.all.order(created_at: :desc).limit(2)
    @recent_likes = Like.all.order(created_at: :desc).limit(2)
  end
end
