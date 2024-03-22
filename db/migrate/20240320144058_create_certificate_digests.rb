class CreateCertificateDigests < ActiveRecord::Migration[6.1]
  def change
    create_table :certificate_digests do |t|
      t.references :registration, null: false, foreign_key: true
      t.string :digest, null: false
      t.string :initials, null: false
      t.timestamps
    end

    add_index :certificate_digests, :digest, unique: true
  end
end
