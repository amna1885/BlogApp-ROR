# frozen_string_literal: true

class Comment < ApplicationRecord
  # Modules
  mount_uploader :attachment, AttachmentUploader

  # Associations
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy
  has_many :reports
  has_many :likes, as: :likeable

  # Validations
  validates :content, presence: true
  validates :post, presence: true

  # Instance Methods
  def reported?
    is_reported
  end
end
