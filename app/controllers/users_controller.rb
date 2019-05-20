# app/controllers/users_controller.rb

class UsersController < ApplicationAuthenticationController
  skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token upon signup
  def create
    begin
      param! :first_name, String, required: true
      build_user(user_params)
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
      :email,
      :password
    )
  end
end