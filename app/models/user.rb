class User < ApplicationRecord
  has_many :roles, dependent: :destroy

  rolify
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_likes
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :suggestions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  # :confirmable if needed
  attr_accessor :login_attempts

  before_save :update_login_attempts

  enum role: { user: 0, moderator: 1, admin: 2 }

  def admin?
    has_role?(:admin)
  end

  def is_moderator?
    has_role?(:moderator)
  end

  def like(post)
    return unless post.present?

    likes.create!(post: post)
  end

  def liked_comment?(comment)
    return unless comment.present?

    comment_likes.create!(comment: comment)
  end

  def unlike_comment(comment)
    return unless comment.present?

    comment_likes.find_by(comment: comment)&.destroy
  end

  def unlike(post)
    likes.find_by(post: post).destroy
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
