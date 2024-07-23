class Comment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :user
  belongs_to :post
  validates :content, presence: true
  validates :post, presence: true
end
