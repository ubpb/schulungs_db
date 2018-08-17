class AddLearningTargetsToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :learning_targets, :text
  end
end
