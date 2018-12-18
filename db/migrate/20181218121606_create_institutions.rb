class CreateInstitutions < ActiveRecord::Migration[5.2]
  def change
    create_table :institutions do |t|
      t.string :title
      t.integer :position, index: true, default: 0

      t.timestamps
    end
  end
end
