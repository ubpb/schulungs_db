class CreateTargetAudiences < ActiveRecord::Migration[5.2]
  def change
    create_table :target_audiences do |t|
      t.string :title

      t.timestamps
    end
  end
end
