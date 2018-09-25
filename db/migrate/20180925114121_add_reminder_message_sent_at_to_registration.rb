class AddReminderMessageSentAtToRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :sent_reminder_message_at, :timestamp, null: true, default: nil
  end
end
