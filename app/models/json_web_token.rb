class JsonWebToken

  def self.encode(payload, exp = 24.hours.from_now)
    # Rails.application.secrets.secret_key_base
    # ....
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def self.decode(token)
    # Rails.application.secrets.secret_key_base
    # ....
    payload = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new payload
  rescue JWT::DecodeError
    nil
  rescue JWT::ExpiredSignature
    nil
  end
end
