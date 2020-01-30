module V1
  class UsersController < V1ApplicationController
    def list_all
      response = { success: true, users: User.all.select(:first_name, :middle_name, :last_name, :email) }
      json_response(response, :created)
    end
  end
end
