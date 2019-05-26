require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication - Reset', type: :request do
  # create test user(s)
  let(:user) { create(:user) }
  let(:unverified_user) { create(:unverified_user) }
  let(:already_reset_user) { create(:already_reset_user) }

  header 'Content-Type', 'Application/json'
  header 'Host', 'api.gamedoora.org'
  header 'Accept', 'application/vnd.gamedoora.v1'

  describe 'auth/reset' do
    post '/auth/reset' do
      let(:raw_post) { params.to_json }
      parameter :email, 'Email for the user to be reset', required: true, type: :string

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
        let(:email) { unverified_user.email }

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
      context 'When user already triggered reset' do
        let(:email) { already_reset_user.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Fail when user already have triggered reset' do
          explanation 'It will throw error of already reset user'
          do_request
          expect(status).to eq(403)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.user_already_trigger_reset)
        end
      end

      # Case 4
      context 'When user successfully triggers reset' do
        let(:email) { user.email }

        # We can provide multiple examples for each endpoint, highlighting different aspects of them.
        example 'Successfully triggers Reset' do
          explanation 'It will throw error of already reset user'
          do_request
          expect(status).to eq(200)
          expect(rspec_doc_json['data']).to be_nil
          expect(rspec_doc_json['message']).to match(Message.sent_reset_token)
        end
      end


    end
  end

end