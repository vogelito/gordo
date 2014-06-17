class UserReciptMailer < ActionMailer::Base
  default from: "from@example.com"

  def recipt_email(user)
   @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def forget_password_mail(user)
  	@user = user  	
  	mail(to: @user.email, subject: 'forget password mail')
  end

end
