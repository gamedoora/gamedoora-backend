# app/controllers/password_reset_controller.rb

class PasswordResetController < ApplicationAuthenticationController
  skip_before_action :authorize_request

  # POST /auth/reset
  def create
    begin
      param! :email, String, required: true

      build_reset_user(params[:email])
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  # POST auth/reset/verify-token
  # params required is verification_code
  def verify_token
    begin
      param! :verification_code, String, required: true

      verify_reset_confirmation_token(params[:verification_code])
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  # POST auth/reset/resend-token
  def resend_token
    begin
      param! :email, String, required: true

      resend_reset_token(params[:email])
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end

  # POST auth/reset/update_password
  def update_password
    begin
      param! :email, String, required: true
      param! :password, String, required: true

      reset_update_password(params[:email], params[:password])
    rescue RailsParam::Param::InvalidParameterError => e
      params_validation_error(e.message)
    end
  end



end

