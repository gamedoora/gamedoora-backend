Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # user authentication related routes
  post 'auth/login', to: 'authentication#authenticate'
  post 'auth/signup', to: 'users#create'


  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    get 'users', to: 'users#list_all'
  end

  match '*path', to: 'application#route_not_found', via: :all
end
