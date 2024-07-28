# frozen_string_literal: true

class Comment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :user
  belongs_to :post, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id'

  validates :content, presence: true
  validates :post, presence: true

  def reported?
    reported
  end
end
