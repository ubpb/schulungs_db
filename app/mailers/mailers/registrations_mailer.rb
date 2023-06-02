class Mailers::RegistrationsMailer < ApplicationMailer

  def registration_confirmation(registration)
    @registration = registration
    @training_course = registration.training_course

    #from_address = @training_course.email_from.presence || "schulung@ub.uni-paderborn.de"

    mail(
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
