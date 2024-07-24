class User < ApplicationRecord
  has_many :roles, dependent: :destroy

  rolify
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
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

  def admin?
    has_role?(:admin)
  end

  def like(post)
    likes.create!(post: post)
  end

  def unlike(post)
    likes.find_by(post: post).destroy
  end

  private

  def update_login_attempts
    self.login_attempts ||= 0
    self.login_attempts += 1
  end
end
