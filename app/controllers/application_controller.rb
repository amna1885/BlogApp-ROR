# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  include CacheControlConcern

  helper_method :logged_in?

  before_action :check_login_attempts, unless: :user_signed_in?
  before_action :authenticate_user!
  before_action :set_cache_control
  before_action :check_login, except: %i[new create]

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: t('errors.access_denied')
  end
end

  private

def check_login
  return if user_signed_in?

  flash[:alert] = t('errors.need_to_login')
  redirect_to new_user_session_path
end

# overwrite
def authenticate_user!
  if! user_signed_in?
  redirect_to new_user_session_path, alert: t('errors.sign_in_first')
end

def check_login_attempts
  return unless user_signed_in? && (current_user.failed_attempts || 0) >= 5

  flash[:alert] = t('errors.account_locked')
  redirect_to root_path
end
