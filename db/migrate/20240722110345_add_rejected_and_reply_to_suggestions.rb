class AddRejectedAndReplyToSuggestions < ActiveRecord::Migration[6.1]
  def change
    add_column :suggestions, :rejected, :boolean
    add_column :suggestions, :reply, :text
  end
end
