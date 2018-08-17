class AddFieldsToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :salutation, :string, null: false
    add_column :registrations, :email, :string
    add_column :registrations, :field_of_interest, :string
  end
end
