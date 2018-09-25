module MailerHelper

  def render_reminder_message(training_course, registration)
    if (message = training_course.reminder_message).present?
      message = message.gsub(/###ANREDE###/, render_salutation(registration))
      message = message.gsub(/###DATUM###/, render_date(training_course))
      message = message.gsub(/###UHRZEIT###/, render_time(training_course))
      message = message.gsub(/###DAUER###/, render_duration(training_course))
      message = message.gsub(/###TREFFPUNKT###/, render_location(training_course))
    end

    message.presence || ""
  end

private

  def render_salutation(registration)
    if registration.salutation == "herr"
      "Sehr geehrter Herr #{registration.lastname}"
    else
      "Sehr geehrte Frau #{registration.lastname}"
    end
  end

  def render_date(training_course)
    l(training_course.date)
  end

  def render_time(training_course)
    training_course.time
  end

  def render_duration(training_course)
    training_course.duration.to_s
  end

  def render_location(training_course)
    training_course.location
  end

end
