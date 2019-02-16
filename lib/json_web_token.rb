# app/lib/json_web_token.rb

class JsonWebToken

  # Secret to encode and decode token
  HMAC_SECRET = Rails.application.credentials[Rails.env.to_sym][:secret_key_base]

  def self.encode(payload, exp = 1.year.from_now)
    # set expiry to 24 hours from creation time or as per required later
    payload[:exp] = exp.to_i

    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end


  def self.decode(token)
    # get payload; first index inn decoded array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, Message.invalid_token
  end
end