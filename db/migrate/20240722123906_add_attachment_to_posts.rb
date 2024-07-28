# frozen_string_literal: true

class AddAttachmentToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :attachment, :string
  end
end
