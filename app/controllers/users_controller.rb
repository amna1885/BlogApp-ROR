class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    Rails.logger.debug "Params: #{params.inspect}"
    @user = User.find(params[:id])
  end
end
