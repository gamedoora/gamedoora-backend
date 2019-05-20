module Authentication
  module SessionConcern
    extend ActiveSupport::Concern

    def create_user_session(params)
      try_login(params)
    end

    private

    def try_login(params)
      user = AuthenticateUser.new(params[:email], params[:password]).call
      build_success_login_response(user)
    end

    def build_success_login_response(user)
      success_authentication_response(user, Message.login_success)
    end

  end
end