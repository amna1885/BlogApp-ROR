class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, default: 'user',  foreign_key: true
  end
end
