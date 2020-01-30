# this module will be responsible for changing state of user account
# and performing various activities like triggering email on changing status
# or probably down the line changing some data in other tables also

# module UserConcerns parent
module UserConcerns
  # module UserStateTransitionConcern
  module UserStateTransitionConcern
    include ActiveSupport::Concern

    # verification of user using email confirmation
    def verify!
      update_attributes(
        confirmation_token: nil,
        confirmed_at: Time.now,
        confirmation_sent_at: nil
      )
    end

    def activate!
      update_attributes(is_active: true)
    end

    def inactivate!
      update_attributes(is_active: false)
    end

    def delete!
      update_attributes(is_deleted: true)
    end

    def undo_delete!
      update_attributes(is_deleted: false)
    end

    def reset!
      update_attributes(
        reset_password_token: self.reset_password_token || SecureRandom.urlsafe_base64.to_s,
        reset_password_sent_at: Time.now
      )
    end

    def verify_reset!(password)
      update_attributes(
        reset_password_token: nil,
        reset_password_sent_at: nil,
        password: password
      )
    end
  end
end