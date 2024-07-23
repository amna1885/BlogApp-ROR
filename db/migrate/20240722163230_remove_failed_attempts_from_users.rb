class RemoveFailedAttemptsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :failed_attempts, :integer, if_exists: true
  end
end
