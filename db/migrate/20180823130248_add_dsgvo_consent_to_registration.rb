class AddDsgvoConsentToRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :dsgvo_consent, :boolean, null: false, default: false
  end
end
