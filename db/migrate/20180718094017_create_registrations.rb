class CreateRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :registrations do |t|
      t.belongs_to :training_course, null: false, index: true, foreign_key: true
      t.string     :firstname, null: false
      t.string     :lastname, null: false
      t.text       :notes
    end
  end
end
