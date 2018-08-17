class ChangeDateForTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :time, :string
    change_column :training_courses, :date, :date
  end
end
