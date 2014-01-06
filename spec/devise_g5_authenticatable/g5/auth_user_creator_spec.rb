require 'spec_helper'

describe Devise::G5::AuthUserCreator do
  let(:creator) { described_class.new }

  describe '#create' do
    subject(:create) { creator.create(model) }

    let(:model) { build_stubbed(:user, updated_by: updated_by) }

    let(:auth_client) { double(:g5_authentication_client, create_user: auth_user) }
    let(:auth_user) { double(:auth_user, id: uid, email: model.email) }
    let(:uid) { 'remote-auth-user-42' }
    before do
      allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
    end

    context 'when user is created by another user' do
      let(:updated_by) { build_stubbed(:user) }

      context 'when user create is successful' do
        it 'should use the token for updated_by_user to call g5 auth' do
          expect(G5AuthenticationClient::Client).to receive(:new).
            with(access_token: updated_by.g5_access_token).
            and_return(auth_client)
          create
        end

        it 'should create a user with the specified email' do
          expect(auth_client).to receive(:create_user).
            with(hash_including(email: model.email)).
            and_return(auth_user)
          create
        end

        it 'should create a user with the specified password' do
          expect(auth_client).to receive(:create_user).
            with(hash_including(password: model.password)).
            and_return(auth_user)
          create
        end

        it 'should create a user with the specified password confirmation' do
          expect(auth_client).to receive(:create_user).
            with(hash_including(password_confirmation: model.password_confirmation)).
            and_return(auth_user)
          create
        end
      end

      context 'when user create is unsuccessful' do
        before do
          allow(auth_client).to receive(:create_user).and_raise('Error!')
        end

        it 'should raise an exception' do
          expect { create }.to raise_error
        end
      end
    end

    context 'when there is no value for updated_by' do
      let(:updated_by) {}

      it 'should use the user token to call g5 auth' do
        expect(G5AuthenticationClient::Client).to receive(:new).
          with(access_token: model.g5_access_token)
        create
      end
    end
  end
end
