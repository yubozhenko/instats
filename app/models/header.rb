class Header < ApplicationRecord
  DEFAULT_HEADERS = {
      'User-Agent': nil,
      Accept: DeviceConfig::HEADER[:accept],
      'Accept-Encoding': DeviceConfig::HEADER[:encoding],
      'Accept-Language': 'en-US',
      'X-IG-Capabilities': DeviceConfig::HEADER[:capabilities],
      'X-IG-Connection-Type': DeviceConfig::HEADER[:type],
      Cookie: nil
  }
  def self.headers(user_agent,auth_info)
    DEFAULT_HEADERS[:'User-Agent'] = user_agent
    DEFAULT_HEADERS[:Cookie] = auth_info
    DEFAULT_HEADERS
  end
end