# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :comment, optional: true
end
