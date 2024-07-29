# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post, only: %i[create edit update show new]
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :authenticate_user! # Ensure user is authenticated

  def index
    @comments = if current_user.moderator?
                  Comment.where(reported: true)
                else
                  Comment.all
                end
  end

  def new
    @comment = @post.comments.new(parent_id: params[:comment_id])
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.parent_id = params[:parent_id]
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'Comment was successfully created.'
    else
      render 'posts/show'
    end
  end

  def show; end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def report_comment
    @comment = Comment.find(params[:id])
    @comment.update(reported: true)
    redirect_to root_path, notice: 'Comment has been reported successfully'
  end

  def reported_comments
    @comments = Comment.where(reported: true)
  end

  def reported
    @reported_comments = Comment.where(reported: true)
  end

  def unreport_comment
    @comment = Comment.find(params[:id])
    @comment.update(reported: false)
    redirect_to reported_comments_path, notice: 'Comment has been unreported succesfully'
  end

  def unpublish_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to reported_comments_path, notice: 'Comment was successfully unpublished'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post), notice: 'Comment was successfully deleted.'
  end

  def like
    @comment = Comment.find_by(id: params[:id])
    if @comment
      current_user.liked_comment?(@comment)
      redirect_to request.referer, notice: 'Comment liked successfully'
    else
      redirect_to root_path, alert: 'Comment not found'
    end
  end

  def unlike
    @comment = Comment.find_by(id: params[:id])
    if @comment
      current_user.unlike_comment(@comment)
      current_user.comment_likes.find_by(comment: @comment)&.destroy
      redirect_to request.referer, notice: 'Comment unliked successfully'
    else
      redirect_to root_path, alert: 'Comment not found'
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id]) if params[:post_id].present?
  end

  def set_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :attachment, :user_id)
  end
end
