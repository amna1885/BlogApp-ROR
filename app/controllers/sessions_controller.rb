class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user&.authenticate(params[:session][:password])
      log_in(user)
    else
      flash.now[:alert] = 'There was something wrong with your login details'
      render 'new'
    end
  end

  def destroy
    reset_session
    flash[:notice] = 'Logged out'
    redirect_to root_path
  end

  private

  def log_in(user)
    reset_session
    session[:user_id] = user.id
    flash[:notice] = 'Logged in successfully'
    redirect_to user
  end
end
