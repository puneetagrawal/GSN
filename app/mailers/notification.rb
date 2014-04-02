class Notification < ActionMailer::Base
  default from: "registration@ssdcafe.org"

  def send_confirmation_email(identity)
  	@identity = identity
  	mail to: identity.email,
  	     subject: 'Confirmation Instruction'
  end
end
