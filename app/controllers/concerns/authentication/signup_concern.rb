#
# **************
# SIGNUP MODULE
# **************
#
# This module will be responsible for
# all the functions/methods at once place
# making the signup process feasible
#

module Authentication
  # Module SignupConcern - for Signup Module
  module SignupConcern
    extend ActiveSupport::Concern

    # all the params required for signing up should be here
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
      user = User.create_user(params)
      build_success_signup_response(user, Settings.user.is_verifiable.present?)

      # send user welcome email
      Mailers::AuthenticationMailer.signup_mail(user).deliver_later

      # only send confirmation token if system allows
      if user.confirmation_token.present? && Settings.user.is_verifiable.present?
        Mailers::AuthenticationMailer.send_confirmation_token_mail(user).deliver_later
      end
    end

    def build_user_exists_response
      fail_authentication_response(Message.user_exists, :conflict)
    end

    # if is_verifiable is not present in config, then authenticate user session
    def build_success_signup_response(user, is_verifiable)
      success_authentication_response(
        user,
        Message.account_created,
        :created,
        is_verifiable.present? ? nil : request.remote_ip
      )
    end
  end
end
