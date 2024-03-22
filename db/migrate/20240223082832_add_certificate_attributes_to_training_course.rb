class AddCertificateAttributesToTrainingCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :training_courses, :certificate_learning_results, :text, null: true
    add_column :training_courses, :certificate_signature, :string, null: true
  end
end
