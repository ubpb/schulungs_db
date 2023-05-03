class AddStatisticsFieldsToTrainingCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :training_courses, :statistics_lecturer, :string
    add_column :training_courses, :statistics_organization_types, :integer, null: false, default: 0
    add_column :training_courses, :statistics_forms, :integer, null: false, default: 0
    add_column :training_courses, :statistics_levels, :integer, null: false, default: 0
    add_column :training_courses, :statistics_categories, :integer, null: false, default: 0
    add_column :training_courses, :statistics_audiences, :integer, null: false, default: 0
    add_column :training_courses, :statistics_focus, :integer, null: false, default: 0
  end
end
