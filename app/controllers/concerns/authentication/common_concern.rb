module Authentication
  module CommonConcern
    extend ActiveSupport::Concern

    def success_authentication_response(user, message, status = :ok)
      json_response(message, user_response_object(user), status)
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
                dob: user.dob },
        auth_token: AuthenticateUser.auth_token(user.id)

      }
    end

  end
end
