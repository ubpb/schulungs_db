class CreateJoinTableCategoryTrainingCourse < ActiveRecord::Migration[5.2]
  def change
    create_join_table :categories, :training_courses do |t|
      t.references :category, index: true, foreign_key: true
      t.references :training_course, index: true, foreign_key: true
    end
  end
end
