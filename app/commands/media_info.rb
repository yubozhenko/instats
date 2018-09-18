class MediaInfo < Instagram
  def user_media(user_name, limit)
    all_media = []
    media = JSON.parse HttpClient.get(DeviceConfig::URL+"feed/user/#{user_name}/username/?&rank_token=#{@@rank_token}", @@headers).body
    all_media += media['items']
    while media['next_max_id']
      media = JSON.parse HttpClient.get(DeviceConfig::URL+"feed/user/"+
                                            "#{user_name}/username/?&rank_token=#{@@rank_token}&max_id=#{media['next_max_id']}", @@headers).body
      all_media+=media['items']
      sleep(1)
    end
    all_media
  end

  def media_comments(media_id)
    all_comments = []
    media = JSON.parse HttpClient.get(DeviceConfig::URL+"media/#{media_id}/comments/", @@headers).body
    all_comments += media['comments']
    while media['next_max_id']
      media = JSON.parse HttpClient.get(DeviceConfig::URL+"media/#{media_id}/comments/?max_id=#{media['next_max_id']}", @@headers).body
      all_comments+=media['comments']
      sleep(1)
    end
    all_comments
  end
end