class ModeratorDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[approve reject]

  def index
    @posts = Post.pending_approval
  end

  def approve
    if @post.approve!
      redirect_to moderator_path, notice: 'Post approved successfully'
    else
      redirect_to moderator_path, alert: 'Failed to approve post'
    end
  end

  def reject
    if @post.reject!
      redirect_to moderator_path, notice: 'Post rejected successfully'
    else
      redirect_to moderator_path, alert: 'Failed to reject post'
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end
end
