class AddDurationToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :duration, :integer
  end
end
