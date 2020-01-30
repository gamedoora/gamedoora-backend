#
# ***************
# SESSION MODULE
# ***************
#
# This module will responsible for
# maintaining or creating user sessions
# Also destroying of user session
#

module Authentication
  # Module SessionConcern - Session Module
  module SessionConcern
    extend ActiveSupport::Concern

    def create_user_session(params, ip_address)
      try_login(params, ip_address)
    end

    private

    def try_login(params, ip_address)
      user = AuthenticateUser.new(params[:email], params[:password], ip_address).call
      build_success_login_response(user)
    end

    def build_success_login_response(user)
      success_authentication_response(user, Message.login_success, :ok, request.remote_ip)
    end

  end
end