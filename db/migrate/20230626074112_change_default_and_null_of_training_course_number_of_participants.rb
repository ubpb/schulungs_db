class ChangeDefaultAndNullOfTrainingCourseNumberOfParticipants < ActiveRecord::Migration[6.1]
  def change
    change_column_default :training_courses, :number_of_participants, from: nil, to: 0
  end
end
