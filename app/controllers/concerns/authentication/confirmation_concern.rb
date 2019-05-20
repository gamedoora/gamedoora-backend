####
# ********************
# CONFIRMATION MODULE
# *******************
#
#
# Confirmation Whole module is configurable as explained below
#
#
# ============
# confirmation
# ============
# is based on Settings.user.is_verifiable
# if it is set, only then user will be asked to be verified
#
# =========================
# confirmation token expiry
# =========================
# is based on Settings.user.confirmation_token_expiry

module Authentication
  # module ConfirmationConcern - includes all the functions related to confirmation
  module ConfirmationConcern
    extend ActiveSupport::Concern

    # param required verification_code
    def verify_email(verification_code)
      build_unauthorized_verification_response && return unless Settings.user.is_verifiable.present?
      user = User.where(confirmation_token: verification_code.to_s.strip).first
      build_invalid_confirmation_token_response && return unless user.present?
      build_already_verified_account_response && return if user.confirmed_at.present?
      build_expired_confirmation_token_response && return if (user.confirmation_sent_at + Settings.user.confirmation_token_expiry) < Time.now
      user.verify!
      Mailers::AuthenticationMailer.successfully_verified_account_mail(user).deliver_later
      build_verification_success_response(user)
    end

    def send_confirmation_token(email)
      build_unauthorized_verification_response unless Settings.user.is_verifiable.present?
      user = User.where(email: email.to_s.strip.downcase).first
      build_email_not_found_response && return unless user.present?
      build_already_verified_account_response && return if user.confirmed_at.present?
      build_unauthorized_verification_response && return unless user.confirmation_token.present?
      user.create_confirmation_token
      Mailers::AuthenticationMailer.send_confirmation_token_mail(user).deliver_later
      build_verification_sent_successful_response
    end

    private

    def build_invalid_confirmation_token_response
      fail_authentication_response(Message.invalid_confirmation_token, :unprocessable_entity)
    end

    def build_expired_confirmation_token_response
      fail_authentication_response(Message.expired_confirmation_token, :unprocessable_entity)
    end

    def build_verification_success_response(user)
      success_authentication_response(user, Message.verified_confirmation_token, :ok, request.remote_ip)
    end

    def build_email_not_found_response
      fail_authentication_response(Message.email_not_found, :unprocessable_entity)
    end

    def build_already_verified_account_response
      fail_authentication_response(Message.user_already_verified, :conflict)
    end

    def build_unauthorized_verification_response
      fail_authentication_response(Message.unauthorized, :unauthorized)
    end

    def build_verification_sent_successful_response
      success_authentication_response(nil, Message.sent_verification_code, :ok)
    end

  end
end