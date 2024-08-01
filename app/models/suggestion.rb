# frozen_string_literal: true

class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Suggestion', optional: true
  has_many :replies, class_name: 'Suggestion', foreign_key: 'parent_id'

  validates :content, presence: true
  validates :reply, presence: true, if: -> { !reply.nil? }
end
