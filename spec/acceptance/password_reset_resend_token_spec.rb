require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Reset - Resend Token', type: :request do
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

  describe 'auth/reset/resend-token' do
    post '/auth/reset/resend-token' do
      let(:raw_post) { params.to_json }
      parameter :email, 'Email of the user', required: true, type: :string

      # Case 1
      context 'When wrong email is entered' do
        let(:email) { Faker::Internet.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail due to wrong email' do
          explanation 'It will throw error of email not found'
          do_request
          expect(status).to eq(422)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.email_not_found)
        end
      end

      # Case 2
      context 'When user is not confirmed' do
        let(:email) { unverified_reset_user.email }

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
      context 'When user have not triggered reset' do
        let(:email) { user.email }
        let(:password) { 'NewPassword' }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail when user have not triggered reset password' do
          explanation 'It will throw error unauthorized'
          do_request
          expect(status).to eq(401)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.unauthorized)
        end
      end

      # Case 4
      context 'When successfully reset token is sent' do
        let(:email) { reset_user.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Successfully re-send token' do
          explanation 'It will resend token email'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.sent_reset_token)
        end
      end

    end
  end

end