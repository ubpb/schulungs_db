namespace :app do
  namespace :mailer do
    desc "Sent reminder messages."
    task :sent_reminder_messages => :environment do
      TrainingCourse.upcoming.published.includes(:registrations).where("date_and_time <= ?", 3.days.from_now.end_of_day).each do |tc|
        if tc.reminder_message.present?
          tc.registrations.each do |r|
            if r.sent_reminder_message_at.blank?
              Mailers::TrainingCoursesMailer.reminder_message(tc, r).deliver
              r.update_column(:sent_reminder_message_at, Time.zone.now)
            end
          end
        end
      end
    end
  end
end
