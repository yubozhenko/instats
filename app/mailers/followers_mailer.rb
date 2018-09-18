class FollowersMailer < ApplicationMailer

  def stats_mail
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
        address: "smtp.gmail.com",
        port: 587,
        domain: 'gmail.com',
        Authentication: "plain",
        enable_starttls_auto: true,
        user_name: 'instats.watcher',
        password: '8mbnDo42'
    }
    @user = params[:user]
    mail(to: @user.email, subject: 'Here latest statistics')
  end
end