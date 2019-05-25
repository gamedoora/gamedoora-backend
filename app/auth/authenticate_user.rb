# frozen_string_literal: true

# app/auth/authenticate_user.rb
class AuthenticateUser
  attr_accessor :user
  attr_reader :ip_address

  def initialize(email, password, ip_address = nil)
    @email = email
    @password = password
    @ip_address = ip_address
  end

  def self.auth_token(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # Service entry point
  def call
    call_user
    build_session
    user
  end

  def call_without_password
    @user = User.find_by(email: email.to_s.strip.downcase)
    build_session
    user
  end

  def build_session
    if ip_address.present?
      user.update_attributes(
        sign_in_count: user.sign_in_count.to_i + 1,
        last_sign_in_at: user.current_sign_in_at,
        current_sign_in_at: Time.now,
        last_sign_in_ip: user.current_sign_in_ip,
        current_sign_in_ip: ip_address
      )
    end
  end

  private

  attr_reader :email, :password

  # verify user credentials
  def call_user
    @user = User.find_by(email: email.to_s.strip.downcase)

    # check if user exists
    raise(ExceptionHandler::AuthenticationError, Message.user_not_exists) unless user.present?

    if Settings.user.is_verifiable.present?
      # check if user is verified or not
      raise(ExceptionHandler::AuthenticationError::UnverifiedUser, Message.unverified_user) if user.not_confirmed?
    end

    # check if user is inactive
    raise(ExceptionHandler::AuthenticationError::LockedUser, Message.inactive_user) if user.inactive?

    # check if user in deleted
    raise(ExceptionHandler::AuthenticationError::DeletedUser, Message.deleted_user) if user.deleted?

    # verify user credentials and match passwords
    return user if user&.authenticate(password.to_s.strip)

    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

end