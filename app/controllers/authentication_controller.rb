# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  # return auth token once user is authenticated
  def authenticate
    user =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(message: Message.login_success, auth_token: AuthenticateUser.auth_token(user.id))

  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end