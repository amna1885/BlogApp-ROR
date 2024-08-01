# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_many :roles, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :suggestions, dependent: :destroy

  before_save :update_login_attempts

  attr_accessor :login_attempts
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
