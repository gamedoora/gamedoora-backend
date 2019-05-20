# custom exception handler for apis

module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom attributes
  class AuthenticationError < StandardError
    class LockedUser < StandardError
    end

    class DeletedUser < StandardError
    end

    class UnverifiedUser < StandardError
    end
  end
  class MissingToken < StandardError
  end
  class InvalidToken < StandardError
  end
  class UnhandledError < StandardError
  end

  included do
    rescue_from ::ActionController::RoutingError do |e|
      json_error_response(e.message, nil, :not_found)
    end
    rescue_from StandardError, with: :unhandled_exception
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorised_request
    rescue_from ExceptionHandler::AuthenticationError::LockedUser, with: :inactive_user
    rescue_from ExceptionHandler::AuthenticationError::DeletedUser, with: :deleted_user
    rescue_from ExceptionHandler::AuthenticationError::UnverifiedUser, with: :unverified_user
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
  end

  private

  def four_twenty_two(e)
    json_error_response(e.message, nil, :unprocessable_entity)
  end

  def unauthorised_request(e)
    json_error_response(e.message, nil, :unauthorized)
  end

  def inactive_user(e)
    json_error_response(e.message, nil, :forbidden)
  end

  def deleted_user(e)
    json_error_response(e.message, nil, :forbidden)
  end

  def unverified_user(e)
    json_error_response(e.message, nil, :forbidden)
  end

  def unhandled_exception(e)
    Rails.logger.error("EXCEPTION ERROR - #{e}, Time = #{Time.now}")
    json_error_response(Message.something_went_wrong, nil, :internal_server_error)
  end

  def no_route_found(e)
    Rails.logger.error("NO ROUTE EXCEPTION ERROR - #{e}, Time = #{Time.now}")
    json_error_response('No Route Found', nil, 404)
  end


end

