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

    def reset?
      reset_password_token.present?
    end

    def not_reset?
      !reset?
    end
  end
end