# frozen_string_literal: true

class Post < ApplicationRecord
  # mount_uploader :attachment, AttachmentUploader
  has_rich_text :description
  has_one_attached :attachment

  belongs_to :user
  belongs_to :reporter, class_name: 'User', optional: true, dependent: :destroy
  has_many :likes, as: :likeable
  has_many :comments, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  accepts_nested_attributes_for :comments

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_initialize :set_pending_status, if: :new_record?

  validates :title, presence: true,
                    length: { minimum: 5, maximum: 10, message: I18n.t('errors.messages.title_length') }
  validates :description, presence: true,
                          length: { minimum: 10, message: I18n.t('errors.messages.description_length') }

  scope :pending_approval, -> { where(is_approved: false, status: 'pending') }
  scope :approved, -> { where(is_approved: true) }
  scope :recent_posts, -> { order(created_at: :desc).limit(5) }
  scope :moderated, -> { where.not(is_approved: nil) }
  scope :reported_posts, -> { where(is_reported: true) }

  def approve
    update(is_approved: true)
  end

  def reject
    update(is_approved: false)
  end

  private

  def set_pending_status
    self.status ||= :pending
  end
end
