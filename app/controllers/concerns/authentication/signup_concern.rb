module Authentication
  module SignupConcern
    extend ActiveSupport::Concern

    def build_user(params)
      build_user_exists_response && return if user_exists?(params[:email])
      create_user(params)
    end

    private

    # params[:email]
    def user_exists?(email)
      User.where(email: email).first.present?
    end

    def create_user(params)
      user = User.create!(params)
      build_success_signup_response(user)
      Mailers::AuthenticationMailer.signup(user).deliver_later
    end

    def build_user_exists_response
      fail_authentication_response(Message.user_exists, :conflict)
    end

    def build_success_signup_response(user)
      success_authentication_response(user, Message.account_created, :created)
    end
  end
end
