class ApplicationMailer < ActionMailer::Base
  default from: "schulung@ub.uni-paderborn.de"
  default reply_to: "schulung@ub.uni-paderborn.de"
  layout "mailer"
  add_template_helper(MailerHelper)
end
