class AddPositionToTargetAudiences < ActiveRecord::Migration[5.2]
  def change
    add_column :target_audiences, :position, :integer, index: true

    TargetAudience.order(:title).each.with_index(1) do |target_audience, index|
      target_audience.update_column :position, index
    end
  end
end
