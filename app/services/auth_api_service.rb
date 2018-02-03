class AuthApiService

  attr_reader :headers, :errors

  def initialize(headers = {})
    @headers = headers
    @errors = {}
  end

  def call
    user
  end

  private

  def user
    # valid or invalid ?
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    #@user || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    # JsonWebToken
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header) if http_auth_header
  end

  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?
    errors[:token] = 'Missing token'
    nil
  end
end
