class PostsController < ApplicationController
  include CacheControlConcern
  load_and_authorize_resource

  before_action :authenticate_user!, only: [:create]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :set_cache_control
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
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
end
