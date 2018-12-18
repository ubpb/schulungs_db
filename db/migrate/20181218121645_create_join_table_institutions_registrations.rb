class CreateJoinTableInstitutionsRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_join_table :institutions, :registrations do |t|
      t.references :institution, index: true, foreign_key: true
      t.references :registration, index: true, foreign_key: true
    end
  end
end
