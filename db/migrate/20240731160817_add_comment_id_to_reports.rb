class AddCommentIdToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :comment_id, :integer
  end
end
