class FixTrainingCourseTime < ActiveRecord::Migration[5.2]

  class TrainingCourseFixer < ApplicationRecord
    self.table_name = "training_courses"
  end

  def up
    add_column :training_courses, :date_and_time, :datetime, null: true, index: true

    TrainingCourseFixer.all.each do |t|
      t.update_attributes(date_and_time: Time.parse("#{t.date} #{t.time}"))
    end

    remove_column :training_courses, :date
    remove_column :training_courses, :time

    change_column_null(:training_courses, :date_and_time, false)
  end
end
