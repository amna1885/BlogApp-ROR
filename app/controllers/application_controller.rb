class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  include CacheControlConcern

  helper_method :logged_in?

  before_action :check_login_attempts, if: :user_signed_in?
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_cache_control
  before_action :check_login, except: [:new]

  # before_action :admin_only
  def after_sign_in_path_for(resource)
    dashboard_path # or another path you want to redirect to after sign-in
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end

  private

def check_login
  return if user_signed_in?

  flash[:alert] = 'You need to log in to access this page.'
  redirect_to new_user_session_path
end

def check_login_attempts
  return unless user_signed_in? && (current_user.failed_attempts || 0) >= 5

  flash[:alert] = 'Your account has been locked due to many incorrect attempts'
  redirect_to root_path
end

# def user_not_authorized
#   flash[:alert] = 'You are not authorized to perform this action.'
#   redirect_to(request.referer || root_path)
# end
