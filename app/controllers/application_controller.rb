# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  include CacheControlConcern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  helper_method :logged_in?

  # before_action :check_login_attempts, if: :user_signed_in?
  before_action :authenticate_user!, except: %i[show]
  before_action :set_cache_control
  # before_action :check_login, except: [:new]

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
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

  def record_not_found
    render text: 'Record not found', status: :not_found
  end
end
