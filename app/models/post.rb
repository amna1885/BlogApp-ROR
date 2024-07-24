class Post < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader
  belongs_to :user
  has_many :likes
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments

  validates :title, presence: true,
                    length: { minimum: 5, maximum: 10, message: 'must be between 5 and 10 characters long.' }
  validates :content, presence: true, length: { minimum: 10, message: 'must be at least 10 characters long.' }
end
