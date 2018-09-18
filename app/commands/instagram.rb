class Instagram

  cattr_accessor :logged_user, :rank_token

  def self.current_user_info(user)
    insta_user = User.find_by(username:user.username).user_detail
    HttpClient.get(DeviceConfig::URL + "users/#{insta_user.insta_id}/info/",
                   Header.headers(insta_user.user_agent,insta_user.insta_auth_info))
  end

  def self.login(username, password)
    unless User.find_by(username: username).user_detail
      details = UserDetail.new
      generator = DeviceGenerator.new(username)
      response = HttpClient.post(DeviceConfig::URL + 'accounts/login/', format(
          'ig_sig_key_version=4&signed_body=%s',
          generator.generate_signature(
              device_id: generator.device_id,
              login_attempt_user: 0, password: password, username: username,
              _csrftoken: 'missing', _uuid: generator.generate_uuid
          )), {'User-Agent' => generator.user_agent}
      )
      json_body = JSON.parse response.body
      raise json_body['message'] if json_body['status'] == 'fail'
      str = ''
      response.cookies.each do |k, v|
        str+="#{k}=#{v}; "
      end
      details.insta_auth_info = str
      details.insta_password = password
      details.user_agent = generator.user_agent
      details.insta_id = json_body['logged_in_user']['pk']
      details.rank_token = generator.generate_rank_token(json_body['logged_in_user']['pk'])
      details.created_at = DateTime.now
      user = User.find_by(username: username)
      user.user_detail = details
      user.save
      json_body['logged_in_user']
    end
  end


end