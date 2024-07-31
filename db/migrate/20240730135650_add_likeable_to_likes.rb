class AddLikeableToLikes < ActiveRecord::Migration[6.1]
  def change
    add_column :likes, :likeable_type, :string
    add_column :likes, :likeable_id, :integer
  end
end
