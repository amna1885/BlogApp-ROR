class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true
  validates :reply, presence: true, if: -> { !reply.nil? }
end
