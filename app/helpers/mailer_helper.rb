module MailerHelper
  def render_reminder_message(training_course, registration)
    if (message = training_course.reminder_message).present?
      message = message.gsub(/###ANREDE###/, render_salutation(registration))
      message = message.gsub(/###DATUM###/, render_date(training_course))
      message = message.gsub(/###UHRZEIT###/, render_time(training_course))
      message = message.gsub(/###DAUER###/, render_duration(training_course))
      message = message.gsub(/###TREFFPUNKT###/, render_location(training_course))
      message = message.gsub(/###TITEL###/, render_title(training_course))
    end

    message.presence || ""
  end

  private

  def render_salutation(registration)
    "Hallo #{registration.fullname}"
  end

  def render_date(training_course)
    l(training_course.date_and_time.to_date)
  end

  def render_time(training_course)
    l(training_course.date_and_time.to_time, format: "%H:%M")
  end

  def render_duration(training_course)
    training_course.duration&.to_s.presence || ""
  end

  def render_location(training_course)
    training_course.location
  end

  def render_title(training_course)
    training_course.title
  end
end
