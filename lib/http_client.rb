class HttpClient

  def self.get(url, headers = nil)
    response = RestClient::Request.new(method: :get, url: url,
                                       headers: headers, verify_ssl: false)
                   .execute {|response, _request, _result| response}
    response
  end

  def self.post(url, body = nil, headers = nil)
    payload = body.nil? ? '' : body
    response = RestClient::Request.new(method: :post, url: url,
                                       payload: payload, headers: headers, verify_ssl: false)
                                  .execute {|response, _request, _result| response}
    response
  end

  def self.put(url, body = nil, headers = nil)
    payload = body.nil? ? '' : body
    response = RestClient::Request.new(method: :put, url: url,
                                       payload: payload.to_json, headers: headers, verify_ssl: false)
                                  .execute { |response, _request, _result| response}
    response
  end
end
