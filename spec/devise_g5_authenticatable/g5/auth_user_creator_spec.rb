require 'spec_helper'

describe Devise::G5::AuthUserCreator do
  let(:creator) { described_class.new }

  describe '#create' do
    subject(:create) { creator.create(model) }

    let(:model) { build_stubbed(:user, updated_by: updated_by) }
    let(:updated_by) {}

    let(:auth_client) { double(:g5_authentication_client, create_user: auth_user) }
    let(:auth_user) { double(:auth_user, id: uid, email: model.email) }
    let(:uid) { 'remote-auth-user-42' }
    before do
      allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
    end

    context 'when the new model has no uid' do
      before { model.uid = nil }

      context 'when updated by an existing user' do
        let(:updated_by) { build_stubbed(:user) }

        it 'should use the token for updated_by user to call g5 auth' do
          expect(G5AuthenticationClient::Client).to receive(:new).
            with(access_token: updated_by.g5_access_token).
            and_return(auth_client)
          create
        end

        it 'should create a new auth user with the correct email' do
          expect(auth_client).to receive(:create_user).
            with(hash_including(email: model.email)).
            and_return(auth_user)
          create
        end

        it 'should create a new auth user with the correct password' do
          expect(auth_client).to receive(:create_user).
            with(hash_including(password: model.password)).
            and_return(auth_user)
          create
        end

        it 'should create a new auth user with the correct password confirmation' do
          expect(auth_client).to receive(:create_user).
            with(hash_including(password_confirmation: model.password_confirmation)).
            and_return(auth_user)
          create
        end

        it 'should reset the password' do
          expect { create }.to change { model.password }.to(nil)
        end

        it 'should reset the password_confirmation' do
          expect { create }.to change { model.password_confirmation }.to(nil)
        end
      end

      context 'when auth service returns an error' do
        before do
          allow(auth_client).to receive(:create_user).and_raise('Error!')
        end

        it 'should raise an exception' do
          expect { create }.to raise_error('Error!')
        end
      end

      context 'when not updated by an existing user' do
        # TODO: this is dumb - the user token will always be nil because they don't
        # exist in the auth server yet. Be smarter. (Raise an error? Try the client
        # credentials grant type?)
        it 'should use the user token to call g5 auth' do
          expect(G5AuthenticationClient::Client).to receive(:new).
            with(access_token: model.g5_access_token)
          create
        end
      end
    end

    context 'when new model already has a uid' do
      before { model.uid = 'remote-user-42' }

      it 'should not create a user' do
        expect(auth_client).to_not receive(:create_user)
        create
      end

      it 'should not reset the password' do
        expect { create }.to_not change { model.password }
        expect(model.password).to_not be_empty
      end

      it 'should not reset the password_confirmation' do
        expect { create }.to_not change { model.password_confirmation }
        expect(model.password_confirmation).to_not be_empty
      end
    end
  end
end
