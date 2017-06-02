class ApplicationMailer < ActionMailer::Base
  default from: ENV['mail_fab_sender_address']
  layout 'mailer'
end
