# frozen_string_literal: true

class PostsController < ApplicationController
  include CacheControlConcern
  load_and_authorize_resource

  before_action :authenticate_user!, only: %i[create new]
  before_action :set_post, only: %i[show approve reject report destroy like unreport unpublish]
  before_action :set_cache_control
  before_action :check_post_status, only: %i[approve reject]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    if user_signed_in?
      @reported_posts = Post.reported_posts
      @posts = if current_user.has_role?(:moderator)
                 Post.all
               else
                 Post.where(is_approved: true)
               end
    else
      flash[:error] = 'You need to sign in!!'
      redirect_to new_user_session_path
    end
  end

  def show
    @posts = Post.all
    render text: 'Post not found', status: :not_found if @post.nil?
    @comment = Comment.new
    @suggestions = @post.suggestions
    @reported_posts = Post.where(user: @post.user, is_reported: true)
    render 'show'
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post created successfully'
      redirect_to @post
    else
      flash[:error] = 'There was an error creating the post'
      render :new
    end
  end

  def approve
    @post.update(is_approved: true, status: :approved)
    redirect_to root_path, notice: 'Post approved successfully'
  end

  def reject
    @post.update(is_approved: false, status: :rejected)
    redirect_to root_path, notice: 'Post rejected successfully'
  end

  def pending_approval
    @pending_posts = Post.where(status: 'pending')
  end

  def report
    @post.update(is_reported: true)
    redirect_to root_path, notice: 'Post reported successfully'
  end

  def reported_posts
    @reported_posts = Post.where(is_reported: true)
  end

  def unreport
    @post.update(status: 'rejected', is_reported: false)
    redirect_to reported_posts_path, notice: 'Post was successfully rejected.'
  end

  def unpublish
    @post.update(status: 'rejected', is_reported: true)
    @post.destroy
    redirect_to reported_posts_path, notice: 'Post was successfully unpublished.'
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :attachment, :status, :is_approved, :is_reported)
  end

  def check_post_status
    return unless @post.approved? || @post.rejected?

    redirect_to root_path, alert: 'Post is already approved or rejected'
  end

  def handle_record_not_found
    redirect_to root_path, alert: 'Post not found'
  end
end
