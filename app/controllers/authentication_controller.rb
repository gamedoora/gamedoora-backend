# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationAuthenticationController
  skip_before_action :authorize_request, only: :authenticate

  # return auth token once user is authenticated
  def authenticate
    begin
      param! :email, String, required: true
      param! :password, String, required: true
      create_user_session(auth_params)
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end