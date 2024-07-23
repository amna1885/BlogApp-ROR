class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  before_action :check_login_attempts, if: :user_signed_in?
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private


  def check_login_attempts
    if user_signed_in? && (current_user.failed_attempts || 0) >= 5
      flash[:alert] = "Your account has been locked due to many incorrect attempts"
      redirect_to root_path
    end
  end
end

