# app/controllers/users_controller.rb

class UsersController < ApplicationAuthenticationController
  skip_before_action :authorize_request, only: [:create, :email_verification, :send_verification_code]

  # POST /auth/signup
  # return authenticated token upon signup
  def create
    begin
      param! :first_name, String, required: true

      build_user(user_params)
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  # POST auth/signup/verify-email
  # params required is verification_code
  # return authenticated token upon success
  def email_verification
    begin
      param! :verification_code, String, required: true
      verify_email(params[:verification_code])
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  # POST auth/signup/send-verification-code
  # params required is email
  # return authenticated token upon success
  def send_verification_code
    begin
      param! :email, String, required: true
      send_confirmation_token(params[:email])
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  def check_if_user_already_exists
    User.where(email: params[:email]).first.present? if params[:email].present?
  end

  def validate_params
    params[:email].present? && params[:password].present? && params[:first_name].present?
  end

  private

  def user_params
    params.permit(
      :first_name,
      :last_name, :middle_name,
      :email, :dob, :password
    )
  end
end