#
# ******************************
# COMMON AUTHENTICATION MODULE
# *****************************
#
# This module will contain all the common
# methods and data that can be re-used/shared
# across all the <authentication modules>

module Authentication
  # Module CommonConcern
  module CommonConcern
    extend ActiveSupport::Concern

    # provide ip_address only if you want to make entry of user authentication
    def success_authentication_response(user, message, status = :ok, ip_address = nil)
      if ip_address.present? && user.present?
        AuthenticateUser.new(user.email, nil, ip_address).call_without_password
      end
      json_response(message, user.present? ? user_response_object(user) : nil, status)
    end

    def fail_authentication_response(message, status = :forbidden)
      json_error_response(message, nil, status)
    end

    private

    def user_response_object(user)
      {
        user: { uid: user.uid,
                first_name: user.first_name.titleize,
                middle_name: user.try(:middle_name).try(:titleize),
                last_name: user.try(:last_name).try(:titleize),
                complete_name: user.complete_name_view,
                email: user.email,
                dob: user.dob,
                is_verified: is_verified?(user) },
        auth_token: generate_auth_token(user)
      }
    end

    def is_verified?(user)
      # throw true of is_verifiable is disabled else check user confirmed_at
      !Settings.user.is_verifiable.present? || user.confirmed_at.present?
    end

    def generate_auth_token(user)
      AuthenticateUser.auth_token(user.id) if !Settings.user.is_verifiable.present? || user.confirmed_at.present?
    end

  end
end
