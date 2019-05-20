# app/controllers/users_controller.rb

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token upon signup
  def create
    begin
      param! :first_name, String, required: true


      json_response({ message: Message.params_not_found }, :unprocessable_entity) && return unless validate_params
      json_response({ message: Message.user_exists }, :conflict) && return if check_if_user_already_exists

      user = User.create!(user_params)
      auth_token = AuthenticateUser.new(user.email, user.password).call
      response = { message: Message.account_created, auth_token: AuthenticateUser.auth_token(auth_token.id) }
      json_response(response, :created)
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