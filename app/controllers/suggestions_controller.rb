class SuggestionsController < ApplicationController
  before_action :set_post
  before_action :set_suggestion, only: [:update, :destroy, :reject, :reply]

  def create
    @suggestion = @post.suggestions.build(suggestion_params)
    @suggestion.user = current_user

    if @suggestion.save
      redirect_to @post, notice: 'Suggestion was successfully created.'
    else
      render 'posts/show', alert: 'Error creating suggestion.'
    end
  end

  def update
    if @suggestion.update(suggestion_params)
      redirect_to @post, notice: 'Suggestion was successfully updated.'
    else
      render 'posts/show', alert: 'Error updating suggestion.'
    end
  end

  def destroy
    @suggestion.destroy
    redirect_to @post, notice: 'Suggestion was successfully deleted.'
  end

  def reject
    @suggestion.update(rejected: true)
    redirect_to @post, notice: 'Suggestion was successfully rejected.'
  end

  def reply
    @suggestion.update(reply: params[:reply])
    redirect_to @post, notice: 'Reply was successfully added to the suggestion.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_suggestion
    @suggestion = @post.suggestions.find(params[:id])
  end

  def suggestion_params
    params.require(:suggestion).permit(:content, :rejected, :reply)
  end
end