require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Reset - Update Password', type: :request do

  explanation 'This api follows by verify token api.
Use this api only once successfully called => Reset - verify token API'
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

  describe 'auth/reset/update-password' do
    post '/auth/reset/update-password' do
      let(:raw_post) { params.to_json }
      parameter :email, 'Email of the user', required: true, type: :string
      parameter :password, 'New password to be updated', required: true, type: :string


      # Case 1
      context 'When wrong email is entered' do
        let(:email) { Faker::Internet.email }
        let(:password) { 'NewPassword' }

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
        let(:password) { 'NewPassword' }

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
      context 'When reset token is expired' do
        let(:email) { reset_expired_user.email }
        let(:password) { 'NewPassword' }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail when reset token is expired' do
          explanation 'It will throw error of unauthorized'
          do_request
          expect(status).to eq(401)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.unauthorized)
        end
      end

      # Case 5
      context 'When user successfully updates password' do
        let(:email) { reset_user.email }
        let(:password) { 'NewPassword' }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Successfully updates password' do
          explanation 'It will update the password'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']).not_to be_nil
          expect(rspec_doc_json['message']).to match(Message.reset_password_updated)
        end
      end

    end
  end

end