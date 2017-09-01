class ApplicationMailer < ActionMailer::Base
  default from: "#{$conf_json['mailer_username']}"
  layout 'mailer'
end
