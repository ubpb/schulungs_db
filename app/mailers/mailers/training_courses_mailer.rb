class Mailers::TrainingCoursesMailer < ApplicationMailer

  def data_changed_notification(training_course, registration)
    @training_course = training_course
    @registration = registration

    from_address = "schulung@ub.uni-paderborn.de"
    if @training_course.email_from.present? and not @training_course.email_from.empty?
      from_address = @training_course.email_from
    end

    mail(
      from: from_address,
      reply_to: from_address,
      to: @registration.email,
      subject: "[UB Paderborn] Änderung eines Schulungstermins"
    )
  end

  def reminder_message(training_course, registration)
    @training_course = training_course
    @registration = registration

    if @training_course.reminder_message.present?

      from_address = "schulung@ub.uni-paderborn.de"
      if @training_course.email_from.present? and not @training_course.email_from.empty?
        from_address = @training_course.email_from
      end

      mail(
        from: from_address,
        reply_to: from_address,
        to: @registration.email,
        subject: "[UB Paderborn] Informationen zu Ihrer Schulungsveranstaltung"
      )
    end
  end

end
