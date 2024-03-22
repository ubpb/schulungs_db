class AddCertificateSentAtToRegistration < ActiveRecord::Migration[6.1]
  def change
    add_column :registrations, :certificate_sent_at, :timestamp, null: true
  end
end
