# frozen_string_literal: true

class ModeratorDashboardController < ApplicationController
  before_action :set_post, only: %i[update]

  def index
    @posts = Post.pending_approval
  end

  def update
    @post = Post.find(params[:id])
    if params[:approve]
      if @post.update(is_approved: true)
        redirect_to moderator_dashboard_path, notice: t('moderator_dashboard.approve.success')
      else
        redirect_to moderator_dashboard_path, alert: t('moderator_dashboard.approve.failure')
      end
    elsif params[:reject]
      @post.destroy
      redirect_to moderator_dashboard_path, notice: t('moderator_dashboard.reject.success')
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end
end
