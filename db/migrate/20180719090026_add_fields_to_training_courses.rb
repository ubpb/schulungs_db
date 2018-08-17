class AddFieldsToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :registration_required, :boolean, null: false, default: false
    add_column :training_courses, :max_no_of_participants, :integer, null: false, default: 0
  end
end
