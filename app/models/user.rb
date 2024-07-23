class User < ApplicationRecord

  resourcify
  rolify


  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :suggestions, dependent: :destroy


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable


         # :confirmable if needed
  attr_accessor :login_attempts

  before_save :update_login_attempts

  private

  def update_login_attempts
    self.login_attempts ||= 0
    self.login_attempts += 1
  end


end

