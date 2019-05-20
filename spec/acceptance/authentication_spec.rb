require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Login API', type: :request do
  # create test user(s)
  let(:user) { create(:user) }
  let(:unverified_user) { create(:unverified_user) }
  let(:inactive_user) { create(:inactive_user) }
  let(:deleted_user) { create(:deleted_user) }


  header 'Content-Type', 'Application/json'
  header 'Host', 'api.gamedoora.org'
  header 'Accept', 'application/vnd.gamedoora.v1'


  describe 'auth/login' do
    # # A specific endpoint
    post '/auth/login' do
      let(:raw_post) { params.to_json }
      parameter :email, 'Email of the user', required: true, type: :string
      parameter :password, 'Password for the user', required: true, type: :string

      context 'When request is valid' do
        let(:email) { user.email }
        let(:password) { user.password }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Login Success' do
          explanation 'It will authenticate the user based on credentials and return authentication JWT token'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']['user']).not_to be_nil
          expect(rspec_doc_json['data']['auth_token']).not_to be_nil
        end
      end

      if Settings.user.is_verifiable.present?
        context 'When unverified user tries to login' do
          let(:email) { unverified_user.email }
          let(:password) { unverified_user.password }

          # We can provide multiple examples for each endpoint, highlighting different aspects of them.
          example 'Unverified User Login Fail' do
            explanation 'It will throw an error for unverified user'
            do_request
            expect(status).to eq(403)
            expect(rspec_doc_json['message']).to match(Message.unverified_user)
          end
        end
      end

      context 'When inactive/blocked user tries to login' do
        let(:email) { inactive_user.email }
        let(:password) { inactive_user.password }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Inactive User Login Fail' do
          explanation 'It will throw an error for inactive user'
          do_request
          expect(status).to eq(403)
          expect(rspec_doc_json['message']).to match(Message.inactive_user)
        end
      end

      context 'When deleted user tries to login' do
        let(:email) { deleted_user.email }
        let(:password) { deleted_user.password }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Deleted User Login Fail' do
          explanation 'It will throw an error for deleted user'
          do_request
          expect(status).to eq(403)
          expect(rspec_doc_json['message']).to match(Message.deleted_user)
        end
      end

      context 'When request is invalid' do
        let(:email) { Faker::Internet.email }
        let(:password) { Faker::Internet.password }
        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Login Fail' do
          explanation 'Login error including invalid credentials or others'
          do_request
          expect(status).to eq(401)
          expect(rspec_doc_json['message']).to match(/Invalid credentials/)
        end
      end

      context 'When parameters error' do
        let(:email) { Faker::Internet.email }
        let(:password) { nil }
        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Login Parameters error' do
          explanation 'Login error including invalid credentials or others'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['message']).to match(/Params validation error/)
          expect(rspec_doc_json['params_validation_message']).not_to be_empty
        end
      end

    end
  end
end