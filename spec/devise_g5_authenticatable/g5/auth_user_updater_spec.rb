require 'spec_helper'

describe Devise::G5::AuthUserUpdater do
  let(:updater) { described_class.new }

  let(:auth_client) { double(:g5_authentication_client, update_user: auth_user) }
  let(:auth_user) { double(:auth_user, id: model.uid, email: model.email) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  let(:model) { build_stubbed(:user, updated_by: updated_by) }

  describe '#update' do
    subject(:update) { updater.update(model) }

    before do
      model.email = updated_email
      model.password = updated_password
      model.password_confirmation = updated_password_confirmation
    end

    let(:updated_email) { 'updated.email@test.host' }
    let(:updated_password) { 'updated_secret' }
    let(:updated_password_confirmation) { 'updated_secret_confirm' }

    context 'when user has been updated_by another user' do
      let(:updated_by) { build_stubbed(:user) }

      context 'when user update is successful' do
        it 'should use the token for updated_by to call g5 auth' do
          expect(G5AuthenticationClient::Client).to receive(:new).
            with(access_token: updated_by.g5_access_token).
            and_return(auth_client)
          update
        end

        it 'should update the email' do
          expect(auth_client).to receive(:update_user).
            with(hash_including(email: updated_email)).
            and_return(auth_user)
          update
        end

        it 'should update the password' do
          expect(auth_client).to receive(:update_user).
            with(hash_including(password: updated_password)).
            and_return(auth_user)
          update
        end

        it 'should update the password_confirmation' do
          expect(auth_client).to receive(:update_user).
            with(hash_including(password_confirmation: updated_password_confirmation)).
            and_return(auth_user)
          update
        end

        it 'should return the updated user' do
          expect(update).to eq(auth_user)
        end
      end

      context 'when user update is unsuccessful' do
        before do
          allow(auth_client).to receive(:update_user).and_raise('Error!')
        end

        it 'should raise an exception' do
          expect { update }.to raise_error
        end
      end
    end

    context 'when there is no value for updated_by' do
      let(:updated_by) {}

      it 'should use the user token to call g5 auth' do
        expect(G5AuthenticationClient::Client).to receive(:new).
          with(access_token: model.g5_access_token)
        update
      end
    end
  end
end
