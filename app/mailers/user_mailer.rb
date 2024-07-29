class UserMailer < ApplicationMailer
  def reminder_email
    @user = params[:user]
    @due_date = @user.borrow_books.first.borrow_date + Settings.day_7.days
    mail(to: @user.account.email,
         subject: t("user_mailer.due_reminder.subject"))
  end
end
