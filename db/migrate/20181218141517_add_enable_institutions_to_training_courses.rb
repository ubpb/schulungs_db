class AddEnableInstitutionsToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :enable_institutions_for_registrations, :boolean, null: false, default: false
    add_column :training_courses, :enable_field_of_interest_for_registrations, :boolean, null: false, default: true
  end
end
