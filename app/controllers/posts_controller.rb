# frozen_string_literal: true

class PostsController < ApplicationController
  include Postable
  include CacheControlConcern
  load_and_authorize_resource

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
      flash[:error] = t('posts.index.need_sign_in')
      redirect_to new_user_session_path
    end
  end

  def show
    @posts = Post.all
    render text: t('posts.not_found'), status: :not_found if @post.nil?
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
      flash[:success] = t('posts.index.create.success')
      redirect_to @post
    else
      flash[:error] = t('posts.index.create.failure')
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: t('posts.index.update.success')
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('posts.index.destroy.success')
  end

  def approve
    approve_post
  end

  def reject
    reject_post
  end

  def report
    report_post
  end

  def unreport
    unreport_post
  end

  def unpublish
    unpublish_post
  end

  def pending_approval
    pending_approval_post
  end

  def reported_posts
    reported_posts
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

    redirect_to root_path, alert: t('posts.already_processed')
  end

  def handle_record_not_found
    redirect_to root_path, alert: t('posts.not_found')
  end
end
