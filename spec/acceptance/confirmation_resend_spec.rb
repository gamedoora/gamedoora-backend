require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Signup - Resend Confirmation', type: :request do
  # create test user(s)
  let(:user) { create(:user) }
  let(:unverified_user) { create(:unverified_user) }
  let(:expired_token_user) { create(:expired_token_user) }
  let(:no_confirmation_token_user) { create(:no_confirmation_token_user) }
  let(:token_verified_user) { create(:token_verified_user) }

  header 'Content-Type', 'Application/json'
  header 'Host', 'api.gamedoora.org'
  header 'Accept', 'application/vnd.gamedoora.v1'

  describe 'auth/signup/send-verification-code' do
    post '/auth/signup/send-verification-code' do
      let(:raw_post) { params.to_json }
      parameter :email, 'Email for the user to be sent confirmation code', required: true, type: :string

      # case 1
      unless Settings.user.is_verifiable.present?
        context 'When settings is_verifiable is disabled' do
          let(:email) { unverified_user.email }

          # We can provide multiple examples for each endpoint, highlighting different aspects of them.
          example 'ReSend Confirmation Token settings disabled' do
            explanation 'It will throw error when global system settings for verification is disabled'
            do_request
            expect(status).to eq(403)
            expect(rspec_doc_json['data']).to be_nil
            expect(rspec_doc_json['message']).to match(Message.unauthorized)
          end
        end
      end

      # Case 2
      context 'When wrong email is entered' do
        let(:email) { Faker::Internet.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'ReSend Confirmation Token fail - wrong email' do
          explanation 'It will throw error of email not found'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.email_not_found)
        end
      end

      # Case 3
      context 'When account is already verified' do
        let(:email) { user.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'ReSend Confirmation Token fail - user is already verified' do
          explanation 'It will throw error for user already verified'
          do_request
          expect(status).to eq(409)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.user_already_verified)
        end
      end

      # Case 4
      context 'Unauthorize request - no confirmation token present in user' do
        let(:email) { no_confirmation_token_user.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'ReSend Confirmation Token fail - no confirmation token present' do
          explanation 'It will throw error for user already verified'
          do_request

          expect(status).to eq(401)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.unauthorized)
        end
      end

      # case 5
      context 'When request is valid' do
        let(:email) { unverified_user.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'ReSend Confirmation Token - Success' do
          explanation 'It will reset token and send again email to user'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.sent_verification_code)
        end
      end
    end
  end


end
