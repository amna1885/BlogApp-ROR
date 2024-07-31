# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post, only: %i[create edit update show new destroy]
  before_action :set_comment, only: %i[show edit update destroy]

  def index
    @comments = if params[:reported].present? && current_user.moderator?
      Comment.where(is_reported: true)
    else
      Comment.all
    end
    @comments ||= []
  end

  def new
    @comment = @post.comments.new(parent_id: params[:comment_id])
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.post_id = params[:post_id]
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: t('comments.create.success')
    else
      flash[:error] = t('comments.errors', errors: @comment.errors.full_messages.to_sentence)
      redirect_to post_path(@post)
    end
  end

  def show; end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: t('comments.update.success')
    else
      render :edit
    end
  end

  def destroy
    if params[:unpublish]
      unpublish_comment
    else
      @comment.destroy
      redirect_to post_path(@post), notice: t('comments.destroy.success')
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    redirect_to root_path, alert: 'Post not found' if @post.nil?
  end

  def set_comment
    @comment = @post.comments.find(params[:id]) if @post
  end

  def comment_params
    params.require(:comment).permit(:content, :attachment, :user_id, :parent_id)
  end

  def unpublish_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comments = Comment.where(is_reported: true)
    redirect_to comments_path(reported: true), notice: t('comments.unpublish.success')
  end
end
