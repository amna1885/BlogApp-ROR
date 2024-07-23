class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
    @comments = Comment.all
    @likes = Like.all
    @recent_posts = Post.all.order(created_at: :desc).limit(5)
    @recent_comments = Comment.all.order(created_at: :desc).limit(5)
    @recent_likes = Like.all.order(created_at: :desc).limit(5)
  end
end
