class Mailers::RegistrationsMailer < ApplicationMailer

  def registration_confirmation(registration)
    @registration = registration
    @training_course = registration.training_course

    from_address = "schulung@ub.uni-paderborn.de"
    if @training_course.email_from.present? and not @training_course.email_from.empty?
      from_address = @training_course.email_from
    end

    mail(
      from: from_address,
      reply_to: from_address,
      to: @registration.email,
      subject: "[UB Paderborn] Ihre Schulungsanmeldung"
    )
  end

  def registration_notification(registration)
    @registration = registration
    @training_course = registration.training_course

    mail(
      to: "schulung@ub.uni-paderborn.de",
      subject: "[SchulungsDB] Eine neue Anmeldung"
    )
  end

end
