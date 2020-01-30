####
# ********************
# Password Reset MODULE
# *******************
#
#
# This module will be responsible for Following
#
# 1. Reset password
# 2. Confirm reset password token
# 3. ReSend Reset Password Token
#

module Authentication
  # module PasswordResetConcern - includes all the functions related to reset password
  module PasswordResetConcern
    extend ActiveSupport::Concern

    # this method will trigger the reset password for a user
    def build_reset_user(email)
      user = User.where(email: email.to_s.strip.downcase).first
      build_email_not_found_response && return unless user.present?
      build_user_not_confirmed_response && return if user.not_confirmed?
      build_already_reset_password && return if user.reset?
      user.reset!
      Mailers::AuthenticationMailer.send_reset_password_token_mail(user).deliver_later
      build_reset_sent_successful_response
    end

    # this method will verify reset password token
    # Dont remove reset token yet
    # Ask user to enter new password
    def verify_reset_confirmation_token(token)
      user = User.where(reset_password_token: token.to_s.strip).first
      build_invalid_reset_token_response && return unless user.present?
      build_user_not_confirmed_response && return if user.not_confirmed?
      build_unauthorized_token_response && return unless user.reset_password_sent_at.present?
      build_expired_reset_token_response && return if user.expired_reset_token?
      build_reset_verify_success_response(user)
    end

    # this method will update the password for the user
    # It will also un-set reset columns in user table
    # Send reset success email
    def reset_update_password(email, password)
      user = User.where(email: email.to_s.strip.downcase).first
      build_email_not_found_response && return unless user.present?
      build_user_not_confirmed_response && return if user.not_confirmed?
      build_unauthorized_token_response && return if user.not_reset?
      build_unauthorized_token_response && return if user.expired_reset_token?
      user.verify_reset!(password.to_s.strip)
      Mailers::AuthenticationMailer.send_reset_successful_mail(user).deliver_later
      build_reset_update_password_response(user)
    end

    # this method will resend reset email
    def resend_reset_token(email)
      user = User.where(email: email.to_s.strip.downcase).first
      build_email_not_found_response && return unless user.present?
      build_user_not_confirmed_response && return if user.not_confirmed?
      build_unauthorized_token_response && return if user.not_reset?
      user.reset!
      Mailers::AuthenticationMailer.send_reset_password_token_mail(user).deliver_later
      build_reset_sent_successful_response
    end

    private

    def build_invalid_reset_token_response
      fail_authentication_response(Message.invalid_reset_token, :unprocessable_entity)
    end

    def build_expired_reset_token_response
      fail_authentication_response(Message.expired_confirmation_token, :unprocessable_entity)
    end

    def build_email_not_found_response
      fail_authentication_response(Message.email_not_found, :unprocessable_entity)
    end

    def build_already_reset_password
      fail_authentication_response(Message.user_already_trigger_reset, :forbidden)
    end

    def build_unauthorized_token_response
      fail_authentication_response(Message.unauthorized, :unauthorized)
    end

    def build_reset_sent_successful_response
      success_authentication_response(nil, Message.sent_reset_token, :ok)
    end

    def build_reset_verify_success_response(user)
      success_authentication_response(user, Message.reset_token_verified, :ok)
    end

    def build_reset_update_password_response(user)
      success_authentication_response(user, Message.reset_password_updated, :ok, request.remote_ip)
    end

    def build_user_not_confirmed_response
      fail_authentication_response(Message.unverified_user, :forbidden)
    end

  end
end