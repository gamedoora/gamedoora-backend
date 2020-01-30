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

    def send_reset_password_token_mail(user)
      @user = user
      mail(to: @user.email, subject: 'Gamedoora | Reset Password Token')
    end

    def send_reset_successful_mail(user)
      @user = user
      mail(to: @user.email, subject: 'Gamedoora | Password reset successful!')
    end
  end
end