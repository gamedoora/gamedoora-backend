# custom exception handler for apis

module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom attributes
  class AuthenticationError < StandardError
  end
  class MissingToken < StandardError
  end
  class InvalidToken < StandardError
  end
  class UnhandledError < StandardError
  end

  included do
    rescue_from ::ActionController::RoutingError do |e|
      json_response({ message: e.message }, :not_found)
    end
    rescue_from StandardError, with: :unhandled_exception
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorised_request
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    # rescue_from ActiveRecord::RecordNotFound do |e|
    #   json_response({message: e.message}, :not_found)
    # end


  end

  private

  def four_twenty_two(e)
    json_response({ success: false, message: e.message }, :unprocessable_entity)
  end

  def unauthorised_request(e)
    json_response({ success: false, message: e.message }, :unauthorized)
  end

  # todo need to use below
  def unhandled_exception(e)
    Rails.logger.error("EXCEPTION ERROR - #{e}")
    json_response({ success: false, message: 'Something went wrong' }, :internal_server_error)
  end

  def no_route_found(e)
    json_response({ success: false, message: 'No Route Found' }, 404)
  end


end

