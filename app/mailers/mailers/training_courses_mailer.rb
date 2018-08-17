class Mailers::TrainingCoursesMailer < ApplicationMailer

  def data_changed_notification(training_course, registration)
    @training_course = training_course
    @registration = registration

    mail(
      to: @registration.email,
      subject: "[UB Paderborn] Änderung eines Schulungstermins"
    )
  end

end
