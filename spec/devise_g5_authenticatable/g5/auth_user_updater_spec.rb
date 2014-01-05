require 'spec_helper'

describe Devise::G5::AuthUserUpdater do
  describe "#update" do
    subject(:update) { updater.update(user) }
    let(:updater) { described_class.new }

    let(:g5_client) { double(:g5_client, update_user: auth_user) }
    let(:auth_user) { {id: auth_user_id, email: email_address} }
    let(:auth_user_id) { 1 }
    let(:email_address) { 'foo@bar.com' }

    before { G5AuthenticationClient::Client.stub(new: g5_client) }

    let(:user) do
      build_stubbed(:user, email: email_address,
                           uid: reputation_user_uid,
                           updated_by: updated_by,
                           password: password,
                           password_confirmation: password_confirmation)
    end

    let(:reputation_user_uid) { "#{auth_user_id}" }
    let(:password) { 'foobar' }
    let(:password_confirmation) { 'notamatch' }

    context 'when user has been updated_by another user' do
      let(:updated_by) { build_stubbed(:user) }

      context 'when user update is successful' do
        it 'should use the token for updated_by to call g5 auth' do
          expect(G5AuthenticationClient::Client).to receive(:new).
            with(access_token: updated_by.g5_access_token)
          update
        end

        it 'should update the email' do
          expect(g5_client).to receive(:update_user).
            with(hash_including(email: email_address))
          update
        end

        it 'should update the password' do
          expect(g5_client).to receive(:update_user).
            with(hash_including(password: password))
          update
        end

        it 'should update the password_confirmation' do
          expect(g5_client).to receive(:update_user).
            with(hash_including(password_confirmation: password_confirmation))
          update
        end

        it 'should return the updated user' do
          expect(update).to include(id: auth_user_id, email: email_address)
        end
      end

      context 'when user update is unsuccessful' do
        before { g5_client.stub(:update_user).and_raise('Error!') }

        it 'should raise an exception' do
          expect { update }.to raise_error
        end
      end
    end

    context 'when there is no value for updated_by' do
      let(:updated_by) {}

      it 'should use the user token to call g5 auth' do
        expect(G5AuthenticationClient::Client).to receive(:new).
          with(access_token: user.g5_access_token)
        update
      end
    end
  end
end
