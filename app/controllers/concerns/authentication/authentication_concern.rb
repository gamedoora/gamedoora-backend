

module Authentication
  module AuthenticationConcern
    extend ActiveSupport::Concern

    include CommonConcern
    include SignupConcern
    include SessionConcern
  end
end