class RemoveSalutationFromRegistrations < ActiveRecord::Migration[7.1]
  def change
    remove_column :registrations, :salutation, :string, null: false
  end
end
