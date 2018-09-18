class FollowersMailerPreview < ActionMailer::Preview
  def email
    FollowersMailer.with(user: User.first).stats_mail
  end
end