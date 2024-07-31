class AddParentIdToSuggestions < ActiveRecord::Migration[6.1]
  def change
    add_column :suggestions, :parent_id, :integer
  end
end
