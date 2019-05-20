# frozen_string_literal: true

# User Model related to users table
# table_name => users


####
#
# ============
# confirmation
# ============
# is based on Settings.user.is_verifiable
# if it is set, only then user will be asked to be verified
#
# =========================
# confirmation token expiry
# =========================
# is based on Settings.user.confirmation_token_expiry

class User < ApplicationRecord
  include UserStateTransitionConcern


  # encrypt password
  has_secure_password

  # Validations
  validates_presence_of :first_name, :email, :password_digest
  validates_uniqueness_of :email


  # CALLBACKS
  before_create :create_confirmation_token

  #### CLASS METHODS START #######
  def self.create_user(params)
    create!(params)
  end

  #### CLASS METHODS ENDS #######


  ###### INSTANCE METHOD STARTS ####

  def complete_name_view
    name = first_name.titleize
    name += "#{name} #{middle_name.titleize}" if middle_name.present?
    name += "#{name} #{last_name.titleize}" if last_name.present?
    name
  end

  ###### INSTANCE METHOD ENDS ####

  private

  def create_confirmation_token
    if Settings.user.is_verifiable.present? && self.confirmation_token.blank?
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
      self.confirmation_sent_at = Time.now
    end
  end

end
