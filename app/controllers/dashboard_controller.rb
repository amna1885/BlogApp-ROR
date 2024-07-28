class DashboardController < ApplicationController
  include CacheControlConcern

  before_action :set_cache_control

  def index
    @posts = Post.all
    @comments = Comment.all
    @likes = Like.all
    @recent_posts = Post.where(reported: false).order(created_at: :desc).limit(2)
    @recent_comments = Comment.all.order(created_at: :desc).limit(2)
    @recent_likes = Like.all.order(created_at: :desc).limit(2)
    @posts = if current_user.is_moderator?
               Post.pending_approval
             else
               Post.approved
             end
  end
end
