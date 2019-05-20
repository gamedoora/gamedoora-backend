# app/controllers/application_authentication_controller.rb
class ApplicationAuthenticationController < ApplicationController
  include Authentication::AuthenticationConcern


end