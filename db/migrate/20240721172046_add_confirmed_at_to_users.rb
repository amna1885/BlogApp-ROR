# frozen_string_literal: true

class AddConfirmedAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :confirmed_at, :datetime
  end
end
