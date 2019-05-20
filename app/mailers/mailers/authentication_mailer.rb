module Mailers
  class AuthenticationMailer < ApplicationMailer


    def signup(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to Gamedoora')
    end
  end
end