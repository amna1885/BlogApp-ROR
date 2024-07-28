# frozen_string_literal: true

class AddAttachmentToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :attachment, :string
  end
end
