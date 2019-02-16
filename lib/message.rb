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

  def self.account_not_created
    I18n.t('authentication.account_created_unsuccessfully')
  end

  def self.expired_token
    I18n.t('authentication.expired_token')
  end

  def self.login_success
    I18n.t('authentication.login_success')
  end
end