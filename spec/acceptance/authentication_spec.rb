require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Login API", type: :request do
  # set test valid and invalid credentials
  let!(:user) { create(:user) }

  header "Content-Type", "Application/json"
  header "Host", "api.gamedoora.org"
  header "Accept", "application/vnd.gamedoora.v1"


  describe "auth/login" do
    # # A specific endpoint
    post "/auth/login" do
      let(:raw_post) { params.to_json }
      parameter :email, "Email of the user"
      parameter :password, "Password for the user"

      context 'When request is valid' do
        before { post '/auth/login', headers: headers }
        let(:email) { user.email }
        let(:password) { user.password }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example "Login Success" do
          explanation "It will authenticate the user based on credentials and return authentication JWT token"
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['auth_token']).not_to be_nil
        end
      end

      context 'When request is invalid' do
        let(:email) { Faker::Internet.email }
        let(:password) { Faker::Internet.password }
        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example "Login Fail" do
          explanation "Login error including invalid credentials or others"
          do_request
          expect(status).to eq(401)
          expect(rspec_doc_json['message']).to match(/Invalid credentials/)
        end
      end

    end
  end
end