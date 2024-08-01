# frozen_string_literal: true
class PostsController < ApplicationController
  include Postable
  include CacheControlConcern
  load_and_authorize_resource

  before_action :set_post, except: %i[index new create reported_posts]
  before_action :set_cache_control
  before_action :check_post_status, only: %i[approve reject]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    if user_signed_in?
      @posts = current_user.has_role?(:moderator) ? Post.all : Post.approved
    else
      flash[:error] = t('posts.index.need_sign_in')
      redirect_to new_user_session_path
    end
  end

  def show
    render text: t('posts.not_found'), status: :not_found if @post.nil?
    @comment = Comment.new
    @suggestions = @post.suggestions
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = t('posts.create.success')
      redirect_to @post
    else
      flash[:error] = t('posts.create.failure')
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: t('posts.update.success')
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('posts.destroy.success')
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
    @reported_posts = Post.where(is_reported: true)
    render 'reported_posts'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :attachment, :status, :is_approved, :is_reported)
  end

  def check_post_status
    if @post.approved? || @post.rejected?
      redirect_to root_path, alert: t('posts.already_processed')
    end
  end

  def handle_record_not_found
    redirect_to root_path, alert: t('posts.not_found')
  end
end
