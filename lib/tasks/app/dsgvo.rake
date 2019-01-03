namespace :app do
  namespace :dsgvo do
    desc "Cleanup personal information to be DSGVO compliant"
    task :cleanup => :environment do
      TrainingCourse.includes(:registrations).where("date_and_time <= ?", 10.days.ago).each do |tc|
        tc.registrations.each do |r|
          r.update_columns(
            firstname: "Gelöscht",
            lastname: "Gelöscht",
            email: "Gelöscht",
            field_of_interest: "",
            notes: ""
          )
        end
      end
    end
  end
end
