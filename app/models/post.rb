class Post < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments
  has_rich_text :description

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_initialize :set_pending_status, if: :new_record?

  validates :title, presence: true,
                    length: { minimum: 5, maximum: 10, message: 'must be between 5 and 10 characters long.' }
  validates :content, presence: true, length: { minimum: 10, message: 'must be at least 10 characters long.' }
  validates :approved, inclusion: { in: [true, false] }, on: :update

  scope :pending_approval, -> { where(approved: false) }
  scope :approved, -> { where(approved: true) }
  scope :recent_posts, -> { order(created_at: :desc).limit(5) }
  scope :moderated, -> { where.not(approved: nil) }

  def approve
    update(approved: true)
  end

  def reject
    update(approved: false)
  end

  private

  def set_pending_status
    self.status ||= :pending
  end
end
