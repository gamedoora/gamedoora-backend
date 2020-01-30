#
# ****************************
# PARENT AUTHENTICATION MODULE
# *****************************
#
# This module will be included by
# all the controllers.
# This module will be hook of all the
# authentication modules
#

module Authentication
  # Module AuthenticationConcern - Parent
  module AuthenticationConcern
    extend ActiveSupport::Concern

    include CommonConcern
    include SignupConcern
    include ConfirmationConcern
    include SessionConcern
    include PasswordResetConcern
  end
end