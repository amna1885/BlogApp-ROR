# frozen_string_literal: true

class Post < ApplicationRecord
  # mount_uploader :attachment, AttachmentUploader
  attr_accessor :attachment

  before_destroy :delete_referencing_records

  belongs_to :user
  belongs_to :reporter, class_name: 'User', optional: true, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  accepts_nested_attributes_for :comments
  has_rich_text :content
  has_one_attached :attachment

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_initialize :set_pending_status, if: :new_record?

  validates :title, presence: true,
                    length: { minimum: 5, maximum: 10, message: 'must be between 5 and 10 characters long.' }
  validates :content, presence: true, length: { minimum: 10, message: 'must be at least 10 characters long.' }
  validates :approved, inclusion: { in: [true, false] }, on: :update

  scope :pending_approval, -> { where(approved: false, status: 'pending') }
  scope :approved, -> { where(approved: true) }
  scope :recent_posts, -> { order(created_at: :desc).limit(5) }
  scope :moderated, -> { where.not(approved: nil) }
  scope :reported_posts, -> { where(reported: true) }

  def approve
    update(approved: true)
  end

  def reject
    update(approved: false)
  end

  private

  def delete_referencing_records
    Comment.where(post_id: id).destroy_all
  end

  def set_pending_status
    self.status ||= :pending
  end
end
