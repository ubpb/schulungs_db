class AddEmailFromToTrainingCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :training_courses, :email_from, :string
  end
end
