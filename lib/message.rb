# app/lib/message.rb
class Message
  def self.not_found(record = 'record')
    I18n.t('authentication.not_found', record: record)
  end

  def self.invalid_credentials
    I18n.t('authentication.invalid_password')
  end

  def self.user_not_exists
    I18n.t('authentication.user_not_exists')
  end

  def self.invalid_token
    I18n.t('authentication.invalid_token')
  end

  def self.missing_token
    I18n.t('authentication.missing_token')
  end

  def self.unauthorized
    I18n.t('authentication.unauthorized_request')
  end

  def self.account_created
    I18n.t('authentication.account_created_successfully')
  end


  def self.user_exists
    I18n.t('authentication.user_already_exists')
  end


  def self.account_not_created
    I18n.t('authentication.account_created_unsuccessfully')
  end

  def self.expired_token
    I18n.t('authentication.expired_token')
  end

  def self.login_success
    I18n.t('authentication.login_success')
  end

  def self.inactive_user
    I18n.t('authentication.inactive_user')
  end

  def self.unverified_user
    I18n.t('authentication.unverified_user')
  end

  def self.invalid_confirmation_token
    I18n.t('authentication.invalid_confirmation_token')
  end

  def self.email_not_found
    I18n.t('authentication.email_not_found')
  end

  def self.user_already_verified
    I18n.t('authentication.user_already_verified')
  end

  def self.expired_confirmation_token
    I18n.t('authentication.expired_confirmation_token')
  end

  def self.sent_verification_code
    I18n.t('authentication.sent_confirmation_token')
  end

  def self.verified_confirmation_token
    I18n.t('authentication.verified_confirmation_token')
  end

  def self.deleted_user
    I18n.t('authentication.deleted_user')
  end

  def self.something_went_wrong
    I18n.t('errors.something_went_wrong')
  end

  def self.params_not_found
    I18n.t('errors.params_not_found')
  end

    def self.params_validation_error
    I18n.t('errors.params_validation')
  end
end