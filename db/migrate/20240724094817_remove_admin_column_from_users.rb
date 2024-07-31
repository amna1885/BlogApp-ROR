# frozen_string_literal: true

class RemoveAdminColumnFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :admin, :boolean
  end
end
