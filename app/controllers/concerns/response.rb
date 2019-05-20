#### RESPONSE FORMAT OF ALL THE APIS
#
# {
#   ==============
#   MANDATORY KEYS
#   ==============
#
#   success: true/false,
#   data: nil/object_hash,
#   message: '',
#   status: status_code,
#
#
#   =============
#   OPTIONAL KEYS
#  ==============
#
#   | will be used for params validation error |
#   --------------------------------------------
#   param_validation_error: <validation error string>,
# }
#


# RESPONSE MODULE - all the response needs to be address from here only
# THIS WILL BE COMMON RESPONSE AREA
module Response
  def json_response(message, obj = nil, status = :ok)
    render json: {
      success: true,
      data: obj || nil,
      message: message || nil
    }, status: status
  end

  def json_error_response(message, obj = nil, status = :internal_server_error)
    render json: {
      success: false,
      data: obj || nil,
      message: message || Message.something_went_wrong,
    }, status: status
  end

  def params_validation_error(error_message, message = nil, obj = nil)
    render json: {
      success: false,
      data: obj || nil,
      message: message || Message.params_validation_error,
      params_validation_message: error_message,
    }, status: :unprocessable_entity
  end
end