# frozen_string_literal: true

class Comment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :user
  belongs_to :post
  has_many :reports
  has_many :likes, as: :likeable
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true
  validates :post, presence: true

  def reported?
    is_reported
  end
end
