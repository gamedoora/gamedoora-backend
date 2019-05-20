module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def json_error_response(error_message, custom_message = nil)
    render json: { message: custom_message || Message.something_went_wrong,
                   error_message: error_message },
           status: :internal_server_error
  end

  def params_validation_error(error_message)
    json_response({ params_validation_message: error_message,
                    message: 'Params not found',
                    success: false }, :unprocessable_entity)
  end
end