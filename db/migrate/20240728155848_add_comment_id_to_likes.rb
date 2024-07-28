# frozen_string_literal: true

class AddCommentIdToLikes < ActiveRecord::Migration[6.1]
  def change
    add_column :likes, :comment_id, :integer
  end
end
