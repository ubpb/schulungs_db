class AddFurtherStatisticsFieldsToTrainingCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :training_courses, :statistics_duration, :integer, null: false, default: 0
    add_column :training_courses, :statistics_lecturer_md, :integer, null: false, default: 0
    add_column :training_courses, :statistics_lecturer_gd, :integer, null: false, default: 0
    add_column :training_courses, :statistics_lecturer_hd, :integer, null: false, default: 0
    add_column :training_courses, :statistics_presence_types, :integer, null: false, default: 0
  end
end
