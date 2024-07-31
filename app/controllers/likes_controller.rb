# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :set_likeable

  def create
    @like = current_user.likes.build(likeable: @likeable)
    if @like.save
      flash[:notice] = likeable_notice(@likeable)
    else
      flash[:alert] = 'Unable to like.'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = current_user.likes.find_by(likeable: @likeable)
    if @like.destroy
      if @likeable.class == Post
        redirect_to post_path(@likeable), notice: 'You unliked this post!'
      elsif @likeable.class == Comment
        redirect_to post_path(@likeable.post), notice: 'You unliked this comment!'
      end
    else
      redirect_to post_path(@likeable), alert: 'Failed to unlike this post!'
    end
  end

  private

  def set_likeable
    case params[:likeable_type]
    when 'Post'
      @likeable = Post.find(params[:post_id])
    when 'Comment'
      @likeable = Comment.find(params[:likeable_id])
    end
  end

  def likeable_notice(likeable, liked = true)
    if likeable.is_a?(Post)
      liked ? 'You liked this post!' : 'You unliked this post!'
    elsif likeable.is_a?(Comment)
      liked ? 'You liked this comment!' : 'You unliked this comment!'
    end
  end

  def likeable_path(likeable)
    if likeable.is_a?(Post)
      post_path(likeable)
    elsif likeable.is_a?(Comment)
      post_path(likeable.post)
    end
  end
end
