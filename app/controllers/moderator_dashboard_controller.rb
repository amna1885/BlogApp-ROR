# frozen_string_literal: true

class ModeratorDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[approve reject]

  def index
    @posts = Post.pending_approval
  end

  def approve
    if @post.approve!
      redirect_to moderator_path, notice: t('moderator_dashboard.approve.success')
    else
      redirect_to moderator_path, alert: t('moderator_dashboard.approve.failure')

    end
  end

  def reject
    if @post.reject!
      redirect_to moderator_path, notice: t('moderator_dashboard.reject.success')
    else
      redirect_to moderator_path, alert: t('moderator_dashboard.reject.failure')
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end
end
