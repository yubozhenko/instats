class DeviceGenerator

  def initialize(username)
    @username = username
  end

  def generate_rank_token(pk)
    format('%s_%s', pk, generate_uuid)
  end

  def compute_hash(data)
    OpenSSL::HMAC.hexdigest OpenSSL::Digest.new('sha256'), DeviceConfig::PRIVATE_KEY[:SIG_KEY], data
  end

  def create_md5(data)
    Digest::MD5.hexdigest(data).to_s
  end

  def generate_device_id
    timestamp = Time.now.to_i.to_s
    'android-' + create_md5(timestamp)[0..16]
  end

  def generate_signature(data)
    data = data.to_json
    compute_hash(data) + '.' + data
  end

  def generate_uuid
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.gsub(/[xy]/) do |c|
      r = (Random.rand * 16).round | 0
      v = c == 'x' ? r : (r & 0x3 | 0x8)
      c.gsub(c, v.to_s(16))
    end.downcase
  end

  def md5
    Digest::MD5.hexdigest(@username)
  end

  def md5int
    (md5.to_i(32) / 10e32).round
  end

  def api
    (18 + (md5int % 5)).to_s
  end

  # @return [string]
  def release
    %w[4.0.4 4.3.1 4.4.4 5.1.1 6.0.1][md5int % 5]
  end

  def dpi
    %w[801 577 576 538 515 424 401 373][md5int % 8]
  end

  def resolution
    %w[3840x2160 1440x2560 2560x1440 1440x2560
         2560x1440 1080x1920 1080x1920 1080x1920][md5int % 8]
  end

  def info
    line = DeviceConfig.devices[md5int % DeviceConfig.devices.count]
    {
        manufacturer: line[0],
        device: line[1],
        model: line[2]
    }
  end

  def useragent_hash
    agent = [api + '/' + release, dpi + 'dpi',
             resolution, info[:manufacturer],
             info[:model], info[:device], @language]

    {
        agent: agent.join('; '),
        version: DeviceConfig::PRIVATE_KEY[:APP_VERSION]
    }
  end

  def user_agent
    format('Instagram %s Android(%s)', useragent_hash[:version], useragent_hash[:agent].rstrip)
  end

  def device_id
    'android-' + md5[0..15]
  end
end