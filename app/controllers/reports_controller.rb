# reports_controller.rb
class ReportsController < ApplicationController
  before_action :set_comment, only: %i[create destroy]

  def create
    @comment.update(is_reported: true)
    redirect_to post_path(@comment.post), notice: t('comments.report.success')
  end

  def destroy
    @comment.update(is_reported: false)
    redirect_to reported_comments_path, notice: t('comments.unreport.success')
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
