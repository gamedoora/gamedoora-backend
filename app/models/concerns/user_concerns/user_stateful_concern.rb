# this module will be responsible for changing state of user account
# and performing various activities like triggering email on changing status
# or probably down the line changing some data in other tables also

# module User parent
module UserConcerns
  # module UserStatefulConcern
  module UserStatefulConcern
    include ActiveSupport::Concern

    def active?
      is_active?
    end

    def inactive?
      !active?
    end

    def deleted?
      is_deleted?
    end

    def not_deleted?
      !deleted?
    end

    def confirmed?
      confirmed_at.present?
    end

    def not_confirmed?
      !confirmed?
    end

    def expired_confirmation_token?
      return true unless confirmation_sent_at.present?

      confirmation_sent_at.present? && ((confirmation_sent_at + Settings.user.confirmation_token_expiry) < Time.now)
    end

    def reset?
      reset_password_token.present?
    end

    def not_reset?
      !reset?
    end

    def expired_reset_token?
      return true unless reset_password_sent_at.present?

      reset_password_sent_at.present? && ((reset_password_sent_at + Settings.user.reset_token_expiry) < Time.now)
    end
  end
end