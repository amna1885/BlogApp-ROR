# frozen_string_literal: true

class SuggestionsController < ApplicationController
  before_action :set_post, only: %i[create update destroy reply edit reject]

  def create
    @suggestion = @post.suggestions.build(suggestion_params)
    @suggestion.user = current_user

    if @suggestion.save
      redirect_to post_path(@post), notice: t('suggestions.create.success')
    else
      flash[:error] = t('suggestions.create.failure')
      redirect_to post_path(@post)
    end
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
  end

  def update
    @suggestion = current_user.suggestions.find(params[:id])
    if params[:reject]
      @suggestion.update(is_rejected: true)
      @suggestion.destroy
      redirect_to @post, notice: t('suggestions.reject.success')
    else
      if @suggestion.update(suggestion_params)
        redirect_to @post, notice: t('suggestions.update.success')
      else
        render 'posts/show'
        flash[:alert] = t('suggestions.update.failure')
      end
    end
  end


  def destroy
    @suggestion = current_user.suggestions.find(params[:id])
    @suggestion.destroy
    redirect_to @post, notice: t('suggestions.destroy.success')
  end

  def reply
    @suggestion = @post.suggestions.find(params[:suggestion_id])
    @reply = @suggestion.replies.build(suggestion_params)
    @reply.user = current_user
    @reply.post = @post

    if @reply.save
      redirect_to post_path(@post), notice: t('suggestions.reply.success')
    else
      redirect_to post_path(@post), notice: t('suggestions.reply.failure')
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def suggestion_params
    params.require(:suggestion).permit(:content, :is_rejected, :parent_id)
  end
end
