# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post, only: %i[create edit update show new]
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :authenticate_user! # Ensure user is authenticated

  def index
    @comments = if current_user.moderator?
                  Comment.where(is_reported: true)
                else
                  Comment.all
                end
  end

  def new
    @comment = @post.comments.new(parent_id: params[:comment_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'Comment created successfully'
    else
      flash[:error] = @comment.errors.full_messages.to_sentence
      redirect_to post_path(@post)
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
    @comment.update(is_reported: true)
    redirect_to root_path, notice: 'Comment has been reported successfully'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Comment not found.'
  end

  def reported_comments
    @comments = Comment.where(is_reported: true)
  end

  def unreport_comment
    @comment = Comment.find(params[:id])
    @comment.update(is_reported: false)
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
    params.require(:comment).permit(:content, :attachment, :user_id, :parent_id)
  end
end
