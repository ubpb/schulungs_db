class Mailers::TrainingCoursesMailer < ApplicationMailer

  def data_changed_notification(training_course, registration)
    @training_course = training_course
    @registration = registration

    mail(
      to: @registration.email,
      subject: "[UB Paderborn] Änderung eines Schulungstermins"
    )
  end

  def reminder_message(training_course, registration)
    @training_course = training_course
    @registration = registration

    if @training_course.reminder_message.present?
      mail(
        to: @registration.email,
        subject: "[UB Paderborn] Informationen zu Ihrer Schulungsveranstaltung"
      )
    end
  end

end
