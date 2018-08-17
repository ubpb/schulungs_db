class AddInternalNotesToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :internal_notes, :text
  end
end
