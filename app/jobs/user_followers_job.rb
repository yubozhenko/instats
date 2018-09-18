class UserFollowersJob < ApplicationJob
  queue_as :default

  def perform(user_param)
    user_followers(user_param)
  end

  def user_followers(user_param)
    stats = Stat.new
    stats.check_date = DateTime.now
    stats.user_id = user_param.id
    resp = JSON.parse HttpClient.get(
        DeviceConfig::URL+"friendships/#{user_param.user_detail.insta_id}/followers/?rank_token=#{user_param.user_detail.rank_token}",
        Header.headers(user_param.user_detail.user_agent, user_param.user_detail.insta_auth_info)).body
    update_followers(resp, stats)
    while resp['next_max_id']
      resp = JSON.parse HttpClient.get(DeviceConfig::URL+"friendships/#{user_param.user_detail.insta_id}/followers/?rank_token=
#{user_param.user_detail.rank_token}&max_id=#{resp['next_max_id']}",
                                       Header.headers(user_param.user_detail.user_agent, user_param.user_detail.insta_auth_info)).body
      update_followers(resp, stats)
    end
    update_user_followers(user_param.id)
    FollowersMailer.with(user:User.find(user_param.id)).stats_mail.deliver
  end

  def update_followers(response, stats)
    response['users'].each do |sub|
      db_sub = Follower.find_by(username: sub['username'])
      unless db_sub
        db_sub = Follower.create!(insta_id: sub['pk'], username: sub['username'])
      end
      stats.followers << db_sub
    end
    stats.save
  end

  def update_user_followers(user_id)
    user = User.find(user_id)
    stats = user.stats.last
    up_followers = stats.followers.pluck(:username)
    current_followers = user.followers.pluck(:username)
    added = up_followers - current_followers
    left = current_followers - up_followers
    added.each {|a_f| stats.updates << Update.create!(stat_id:stats.id, username: a_f, action: 'added')}
    left.each {|l_f| stats.updates << Update.create!(stat_id:stats.id, username: l_f, action: 'left')}
    stats.followers.select do |fol|
      user.followers << fol if added.include?(fol[:username]) && !user.followers.include?(fol)
    end

    user.followers.delete(Follower.where(username: [left]))
    stats.followers_count = stats.followers.count
    stats.new_count = added.count
    stats.left_count = left.count
    stats.save
    user.save
  end
end
