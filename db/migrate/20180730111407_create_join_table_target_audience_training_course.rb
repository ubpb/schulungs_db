class CreateJoinTableTargetAudienceTrainingCourse < ActiveRecord::Migration[5.2]
  def change
    create_join_table :target_audiences, :training_courses do |t|
      t.references :target_audience, index: true, foreign_key: true
      t.references :training_course, index: true, foreign_key: true
    end
  end
end
