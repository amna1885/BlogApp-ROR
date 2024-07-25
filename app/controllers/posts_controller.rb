class PostsController < ApplicationController
  include CacheControlConcern
  load_and_authorize_resource

  before_action :authenticate_user!, only: [:create]
  before_action :set_post, only: %i[show approve reject]
  before_action :set_cache_control
  before_action :check_post_status, only: %i[approve reject]

  def index
    @posts = if current_user.is_moderator?
               Post.all
             else
               Post.where(approved: true)
             end
  end

  def show
    @post = Post.find(params[:id])
    @posts = Post.all
    @comment = Comment.new
    render 'show'
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      if current_user.is_moderator?
        redirect_to posts_path, notice: 'Post was successfully created and is now visible to all users.'
      else
        redirect_to posts_path, notice: 'Post was successfully created and is pending approval.'
      end
    else
      render 'new'
    end
  end

  def approve
    @post = Post.find(params[:id])
    @post.update(approved: true, status: :approved)
    redirect_to root_path, notice: 'Post approved successfully'
  end

  def reject
    @post = Post.find(params[:id])
    @post.update(approved: false, status: :rejected)
    redirect_to root_path, notice: 'Post rejected successfully'
  end

  def pending_approval
    @pending_posts = Post.where(approved: false)
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  def like
    @post = Post.find(params[:id])
    if current_user.likes.where(post: @post).empty?
      current_user.like(@post)
      redirect_to @post, notice: 'You liked this post!'
    else
      current_user.unlike(@post)
      redirect_to @post, notice: 'You unliked this post!'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def check_post_status
    return unless @post.approved? || @post.rejected?

    redirect_to root_path, alert: 'Post is already approved or rejected'
  end
end
