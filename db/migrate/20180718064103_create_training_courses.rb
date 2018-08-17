class CreateTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :training_courses do |t|
      t.string   :title, null: false
      t.string   :location, null: false
      t.datetime :date, null: false, index: true
      t.boolean  :published, null: false, default: false, index: true
      t.text     :description
    end
  end
end
