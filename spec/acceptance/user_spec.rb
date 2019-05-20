require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Signup API', type: :request do
  # set test valid and invalid credentials

  let!(:user) { create(:user) }
  header 'Content-Type', 'Application/json'
  header 'Host', 'api.gamedoora.org'
  header 'Accept', 'application/vnd.gamedoora.v1'

  describe 'POST /auth/signup' do
    # # A specific endpoint
    post '/auth/signup' do
      let(:raw_post) { params.to_json }
      parameter :email, 'Email of the user', required: true, type: :string
      parameter :password, 'Password for the user', required: true, type: :string
      parameter :first_name, 'First name of the user', required: true, type: :string
      parameter :middle_name, 'Middle name of the user', required: false, type: :string
      parameter :last_name, 'Last name of the user', required: false, type: :string


      context 'When request is valid' do
        let(:email) { Faker::Internet.email }
        let(:password) { Faker::Internet.password }
        let(:first_name) { Faker::Name.first_name }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Sign Up Success' do
          explanation 'It will create a entry for a new user based on params and will return JWT Auth token'
          do_request
          expect(status).to eq(201)
          expect(rspec_doc_json['data']['user']).not_to be_nil

          if Settings.user.is_verifiable.present?
            expect(rspec_doc_json['data']['auth_token']).to be_nil
            expect(rspec_doc_json['data']['user']['is_verified']).to match(false)
            expect(rspec_doc_json['message']).to match(Message.unverified_account_created)
          else
            expect(rspec_doc_json['data']['auth_token']).not_to be_nil
            expect(rspec_doc_json['data']['user']['is_verified']).to match(true)
            expect(rspec_doc_json['message']).to match(Message.account_created)
          end
        end
      end

      context 'When request is invalid' do
        let(:email) { Faker::Internet.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'SignUp Parameters error' do
          explanation 'If params are not present, it will throw fail error for signup'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['message']).to match(/Params validation error/)
          expect(rspec_doc_json['params_validation_message']).not_to be_empty
        end
      end

      context 'When user already exists' do
        let(:email) { user.email }
        let(:password) { user.password }
        let(:first_name) { user.first_name }
        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'User exists' do
          explanation 'When user already exists as per email, it will throw conflict error'
          do_request
          expect(status).to eq(409)
          expect(rspec_doc_json['message'])
            .to match(/User with this account already exists/)
        end
      end

    end
  end
end