module Mailers
  class AuthenticationMailer < ApplicationMailer


    def signup_mail(user)
      @user = user
      mail(to: @user.email, subject: 'Gamedoora | Welcome to Gamedoora')
    end

    def send_confirmation_token_mail(user)
      @user = user
      mail(to: @user.email, subject: 'Gamedoora | Confirm your account')
    end

    def successfully_verified_account_mail(user)
      @user = user
      mail(to: @user.email, subject: 'Gamedoora | Account Verified')
    end
  end
end