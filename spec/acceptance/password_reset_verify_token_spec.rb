require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Reset - Verify Token', type: :request do
  explanation 'Before hitting update password, this api needs to be triggered,
when user opens a link to verify token.
Once verified, only then ask for new password and hit reset/update-password API'
  # create test user(s)
  let(:user) { create(:user) }
  let(:unverified_user) { create(:unverified_user) }
  let(:unverified_reset_user) { create(:unverified_reset_user) }
  let(:already_reset_user) { create(:already_reset_user) }
  let(:reset_expired_user) { create(:reset_expired_user) }
  let(:reset_user) { create(:reset_user) }

  header 'Content-Type', 'Application/json'
  header 'Host', 'api.gamedoora.org'
  header 'Accept', 'application/vnd.gamedoora.v1'

  describe 'auth/reset/verify-token' do
    post '/auth/reset/verify-token' do
      let(:raw_post) { params.to_json }
      parameter :verification_code, 'Reset Verification code', required: true, type: :string

      # Case 1
      context 'When invalid reset verification token' do
        let(:verification_code) { Faker::Crypto.md5 }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail due to invalid token' do
          explanation 'It will throw error of invalid token'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.invalid_reset_token)
        end
      end

      # Case 2
      context 'When user is not confirmed' do
        let(:verification_code) { unverified_reset_user.reset_password_token }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail due to not confirmed user' do
          explanation 'It will throw error of unconfirmed user'
          do_request
          expect(status).to eq(403)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.unverified_user)
        end
      end

      # Case 3
      context 'When reset token is expired' do
        let(:verification_code) { reset_expired_user.reset_password_token }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail when reset token is expired' do
          explanation 'It will throw error of expired token'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.expired_confirmation_token)
        end
      end

      # Case 4
      context 'When user successfully verifies reset token' do
        let(:verification_code) { reset_user.reset_password_token }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Successfully verifies reset token' do
          explanation 'It will verifies successfully token'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']).not_to be_nil
          expect(rspec_doc_json['message']).to match(Message.reset_token_verified)
        end
      end


    end
  end

end