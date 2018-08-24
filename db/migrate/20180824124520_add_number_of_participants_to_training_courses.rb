class AddNumberOfParticipantsToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :number_of_participants, :integer, null: true
  end
end
