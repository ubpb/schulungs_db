class AddReminderMessageToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :reminder_message, :text
  end
end
