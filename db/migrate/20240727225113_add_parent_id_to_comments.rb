# frozen_string_literal: true

class AddParentIdToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :parent_id, :integer

    add_index :comments, :parent_id
  end
end
