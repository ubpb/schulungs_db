class AddTimestampsToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:registrations, null: true)
  end
end
