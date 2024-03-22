class Mailers::RegistrationsMailer < ApplicationMailer

  def registration_confirmation(registration)
    @registration = registration
    @training_course = registration.training_course

    from_address = @training_course.email_from.presence || "schulung@ub.uni-paderborn.de"

    mail(
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

  def certificate(registration, cert, cert_filename)
    @registration = registration
    @training_course = registration.training_course

    from_address = @training_course.email_from.presence || "schulung@ub.uni-paderborn.de"

    attachments[cert_filename] = cert

    mail(
      reply_to: from_address,
      to: @registration.email,
      subject: "[UB Paderborn] Ihre Teilnahmebescheinigung"
    )
  end

end
