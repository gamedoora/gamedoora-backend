Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

  match '', to: 'application#ping', via: :all
  # user authentication related routes
  post 'auth/login', to: 'authentication#authenticate'

  # user signup/confirmation/resend confirmation routes
  post 'auth/signup', to: 'users#create'
  post 'auth/signup/verify-email', to: 'users#email_verification'
  post 'auth/signup/send-verification-code', to: 'users#send_verification_code'
  post 'auth/signup/resend-verification-code', to: 'users#send_verification_code'

  # password reset related modules
  post 'auth/reset', to: 'password_reset#create'
  post 'auth/reset/resend-token', to: 'password_reset#resend_token'
  post 'auth/reset/verify-token', to: 'password_reset#verify_token'
  post 'auth/reset/update-password', to: 'password_reset#update_password'

  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    get 'users', to: 'users#list_all'
  end

  match '*path', to: 'application#route_not_found', via: :all
end
