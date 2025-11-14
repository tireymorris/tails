module JWTHelper
  JWT_SECRET = ENV['JWT_SECRET'] || 'change_me_in_production_please_use_long_random_string'
  JWT_ALGORITHM = 'HS256'

  def generate_jwt(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, JWT_SECRET, JWT_ALGORITHM)
  end

  def verify_jwt_token(token)
    return nil unless token

    begin
      decoded = JWT.decode(token, JWT_SECRET, true, algorithm: JWT_ALGORITHM)
      payload = decoded.first
      User.find_by(id: payload['user_id'])
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end
