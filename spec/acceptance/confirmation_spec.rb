require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Verify Email API', type: :request do
  # create test user(s)
  let(:user) { create(:user) }
  let(:unverified_user) { create(:unverified_user) }
  let(:expired_token_user) { create(:expired_token_user) }
  let(:no_confirmation_token_user) { create(:no_confirmation_token_user) }
  let(:token_verified_user) { create(:token_verified_user) }

  header 'Content-Type', 'Application/json'
  header 'Host', 'api.gamedoora.org'
  header 'Accept', 'application/vnd.gamedoora.v1'

  describe 'auth/signup/verify-email' do
    post '/auth/signup/verify-email' do
      let(:raw_post) { params.to_json }
      parameter :verification_code, 'Confirmation Code for the user', required: true, type: :string

      # case 1
      unless Settings.user.is_verifiable.present?
        context 'When settings is_verifiable is disabled' do
          before { post '/auth/signup/verify-email', headers: headers }
          let(:verification_code) { unverified_user.confirmation_token }

          # We can provide multiple examples for each endpoint, highlighting different aspects of them.
          example 'Confirmation settings disabled' do
            explanation 'It will throw error when global system settings for verification is disabled'
            do_request
            expect(status).to eq(403)
            expect(rspec_doc_json['data']).to be_nil
            expect(rspec_doc_json['message']).to match(Message.unauthorized)
          end
        end
      end

      # Case 2
      context 'When wrong token is entered' do
        before { post '/auth/signup/verify-email', headers: headers }
        let(:verification_code) { 'wrongTokenString' }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Confirmation fail - wrong token' do
          explanation 'It will throw error wrong token is entered'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.invalid_confirmation_token)
        end
      end

      # Case 3
      context 'When token is expired' do
        before { post '/auth/signup/verify-email', headers: headers }
        let(:verification_code) { expired_token_user.confirmation_token }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Confirmation fail - expired token (24 hours:configurable)' do
          explanation 'It will throw error expired token is entered'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.expired_confirmation_token)
        end
      end

      # case 4
      context 'When request is valid' do
        before { post '/auth/signup/verify-email', headers: headers }
        let(:verification_code) { unverified_user.confirmation_token }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Confirmation Success' do
          explanation 'It will confirm email address of the user'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']['user']).not_to be_nil
          expect(rspec_doc_json['data']['auth_token']).not_to be_nil
          expect(rspec_doc_json['data']['user']['is_verified']).to match(true)
          expect(rspec_doc_json['message']).to match(Message.verified_confirmation_token)
        end
      end

      # case 5
      context 'When user is already verified' do
        before { post '/auth/signup/verify-email', headers: headers }
        let(:verification_code) { token_verified_user.confirmation_token }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Confirmation Fail - user already verified' do
          explanation 'It will confirm email address of the user'
          do_request
          expect(status).to eq(409)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.user_already_verified)
        end
      end


    end
  end

end