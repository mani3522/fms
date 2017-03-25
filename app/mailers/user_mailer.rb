class UserMailer < ApplicationMailer
	default from: 'n.mani172@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/login'
    mail(to: @user.email, subject: 'New Signup')
  end

	def logged_in(user)
    @user = user
    mail to: user.email, subject: "Account Log In"
  end

	def event_created(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

end
