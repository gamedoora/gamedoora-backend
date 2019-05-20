Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

  # user authentication related routes
  post 'auth/login', to: 'authentication#authenticate'

  # user signup/confirmation/resend confirmation routes
  post 'auth/signup', to: 'users#create'
  post 'auth/verify-email', to: 'users#email_verification'
  post 'auth/send-verification-code', to: 'users#send_verification_code'
  post 'auth/resend-verification-code', to: 'users#send_verification_code'


  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    get 'users', to: 'users#list_all'
  end

  match '*path', to: 'application#route_not_found', via: :all
end
