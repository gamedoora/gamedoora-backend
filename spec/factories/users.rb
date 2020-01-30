FactoryBot.define do
  factory :user do
    first_name "factory"
    email "simran2194@gmail.com"
    password "123456"
    uid "u1234567890"
    confirmation_token nil
    confirmation_sent_at nil
    confirmed_at Time.now

    factory :unverified_user do
      first_name "Unverified User"
      confirmation_token SecureRandom.urlsafe_base64.to_s
      confirmation_sent_at Time.now
      confirmed_at nil
    end

    factory :unverified_reset_user do
      first_name "Unverified Reset User"
      confirmation_token SecureRandom.urlsafe_base64.to_s
      confirmation_sent_at Time.now
      confirmed_at nil
      reset_password_token SecureRandom.urlsafe_base64.to_s
      reset_password_sent_at Time.now
    end

    factory :inactive_user do
      first_name "Inactive user"
      is_active false
    end

    factory :deleted_user do
      first_name "Deleted user"
      is_deleted true
    end

    factory :expired_token_user do
      first_name "Expired user"
      confirmation_token SecureRandom.urlsafe_base64.to_s
      confirmation_sent_at Time.now - 48.hours
      confirmed_at nil
    end

    factory :token_verified_user do
      first_name "Token Verified user"
      confirmation_token SecureRandom.urlsafe_base64.to_s
      confirmation_sent_at Time.now
      confirmed_at Time.now
    end

    factory :no_confirmation_token_user do
      confirmation_token nil
      confirmation_sent_at Time.now - 48.hours
      confirmed_at nil
    end

    factory :reset_user do
      first_name 'Reset User'
      reset_password_token SecureRandom.urlsafe_base64.to_s
      reset_password_sent_at Time.now
    end

    factory :reset_expired_user do
      first_name 'Reset Expired User'
      reset_password_token SecureRandom.urlsafe_base64.to_s
      reset_password_sent_at Time.now - 48.hours
    end

    factory :already_reset_user do
      first_name 'Already reset user'
      reset_password_token SecureRandom.urlsafe_base64.to_s
      reset_password_sent_at Time.now
    end


  end
end


