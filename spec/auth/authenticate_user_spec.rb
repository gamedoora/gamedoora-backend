# frozen_string_literal: true

# spec/auth/authenticate_user_spec.rb
require 'rails_helper'

RSpec.describe AuthenticateUser do
  # create test user
  let(:user) { create(:user) }
  let(:unverified_user) { create(:unverified_user) }
  let(:inactive_user) { create(:inactive_user) }
  let(:deleted_user) { create(:deleted_user) }

  # valid request subject
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }

  # in active user subject
  subject(:inactive_user_auth_obj) { described_class.new(inactive_user.email, inactive_user.password) }

  # in active user subject
  subject(:deleted_user_auth_obj) { described_class.new(deleted_user.email, deleted_user.password) }

  # unverified user subject
  subject(:valid_unverified_auth_obj) { described_class.new(unverified_user.email, unverified_user.password) }

  # unknown user object
  subject(:unknown_auth_obj) { described_class.new('random@gmail.com', 'pass') }

  # invalid request subject
  subject(:invalid_auth_obj) { described_class.new(user.email, 'bar') }

  # Test suite for AuthenticateUser#call
  describe '#call' do

    # error when user doesn't exists
    context 'When user doesnot exists' do
      it 'return error' do
        expect { unknown_auth_obj.call }
          .to raise_error(ExceptionHandler::AuthenticationError, Message.user_not_exists)
      end
    end


    # return token when valid request
    context 'when valid credentials' do
      it 'returns an auth token' do
        user_obj = valid_auth_obj.call
        expect(user_obj).not_to be_nil
      end
    end

    # raise error user is not verified
    context 'When user is not verified' do
      it 'should return forbidden' do
        if Settings.user.is_verifiable.present?
          expect { valid_unverified_auth_obj.call }
            .to raise_error(
                  ExceptionHandler::AuthenticationError::UnverifiedUser,
                  Message.unverified_user
                )
        else
          user_obj = valid_auth_obj.call
          expect(user_obj).not_to be_nil
        end
      end
    end

    # return error when user is inactive
    context 'When user is inactive' do
      it 'should return forbidden' do
        expect { inactive_user_auth_obj.call }
          .to raise_error(
                ExceptionHandler::AuthenticationError::LockedUser,
                Message.inactive_user
              )
      end
    end

    # return error when user is deleted
    context 'When user is deleted' do
      it 'should return forbidden' do
        expect { deleted_user_auth_obj.call }
          .to raise_error(
                ExceptionHandler::AuthenticationError::DeletedUser,
                Message.deleted_user
              )
      end
    end

    # raise Authentication Error when invalid request
    context 'when invalid credentials' do
      it 'raises an authentication error' do
        expect { invalid_auth_obj.call }
          .to raise_error(
                ExceptionHandler::AuthenticationError,
                Message.invalid_credentials
              )
      end
    end
  end
end
