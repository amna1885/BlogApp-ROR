class RenameBooleanColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :reported, :is_reported
    rename_column :posts, :approved, :is_approved
    rename_column :posts, :reported, :is_reported
    rename_column :suggestions, :rejected, :is_rejected
  end
end
