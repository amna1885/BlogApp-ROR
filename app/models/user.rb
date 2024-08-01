# frozen_string_literal: true

class User < ApplicationRecord
  has_many :roles, dependent: :destroy

  rolify
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  attr_accessor :login_attempts

  before_save :update_login_attempts

  enum role: { user: 0, moderator: 1, admin: 2 }

  def admin?
    has_role?(:admin)
  end

  def is_moderator?
    has_role?(:moderator)
  end

  def suggestions_on_own_posts
    Suggestion.joins(:post).where(posts: { user_id: id })
  end

  private

  def update_login_attempts
    self.login_attempts ||= 0
    self.login_attempts += 1
  end
end
