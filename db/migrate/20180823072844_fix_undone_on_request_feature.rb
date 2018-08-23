class FixUndoneOnRequestFeature < ActiveRecord::Migration[5.2]
  def up
    execute "delete from training_courses where on_request = 1"
    change_column_null :training_courses, :location, false
    change_column_null :training_courses, :date, false
    remove_column :training_courses, :on_request
  end
end
