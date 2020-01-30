class ApplicationController < ActionController::API

  include Response
  include ExceptionHandler
  before_action :authorize_request, :set_locale
  skip_before_action :authorize_request, only: [:route_not_found, :ping]

  attr_reader :current_user

  def ping
    json_response('OK' )
  end

  def route_not_found
    json_error_response('No route found')
  end

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  # Check for valid request token and return user
  def get_user
    @current_user = AuthorizeApiRequest.new(request.headers).get_user
  end

  # Set locale method
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def error_occurred
    render :json => { code: 500 }
  end

end
