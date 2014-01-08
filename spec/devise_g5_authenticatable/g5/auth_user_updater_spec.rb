require 'spec_helper'

describe Devise::G5::AuthUserUpdater do
  let(:updater) { described_class.new(model) }

  let(:auth_client) { double(:g5_authentication_client, update_user: auth_user) }
  let(:auth_user) { double(:auth_user, id: model.uid, email: model.email) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  let(:model) { create(:user, updated_by: updated_by) }
  let(:updated_by) {}

  describe '#update' do
    subject(:update) { updater.update }

    context 'when email and password are unchanged' do
      before { model.password = nil }
      before { update }

      it 'should not update the auth service' do
        expect(auth_client).to_not have_received(:update_user)
      end
    end

    context 'when email has changed' do
      before { model.email = updated_email }
      let(:updated_email) { 'updated.email@test.host' }


      context 'when user has been updated by another user' do
        let(:updated_by) { create(:user) }

        context 'when auth user update is successful' do
          before { update }

          it 'should use the token for updated_by to call g5 auth' do
            expect(G5AuthenticationClient::Client).to have_received(:new).
              with(access_token: updated_by.g5_access_token)
          end

          it 'should update the email' do
            expect(auth_client).to have_received(:update_user).
              with(hash_including(email: updated_email))
          end

          it 'should reset the password' do
            expect(model.password).to be_nil
          end

          it 'should reset the password confirmation' do
            expect(model.password_confirmation).to be_nil
          end

          it 'should return the updated user' do
            expect(update).to eq(auth_user)
          end
        end

        context 'when auth service returns an error' do
          before do
            allow(auth_client).to receive(:update_user).and_raise('Error!')
          end

          it 'should raise an exception' do
            expect { update }.to raise_error
          end
        end
      end

      context 'when user has not been updated by another user' do
        before { update }

        it 'should use the user token to call g5 auth' do
          expect(G5AuthenticationClient::Client).to have_received(:new).
            with(access_token: model.g5_access_token)
        end
      end
    end

    context 'when password is set' do
      before do
        model.password = updated_password
        model.password_confirmation = updated_password_confirmation
      end

      let(:updated_password) { 'my_new_secret' }
      let(:updated_password_confirmation) { 'not a match' }

      before { update }

      it 'should update the password' do
        expect(auth_client).to have_received(:update_user).
          with(hash_including(password: updated_password))
        update
      end

      it 'should update the password_confirmation' do
        expect(auth_client).to have_received(:update_user).
          with(hash_including(password_confirmation: updated_password_confirmation))
      end

      it 'should reset the password' do
        expect(model.password).to be_nil
      end

      it 'should reset the password confirmation' do
        expect(model.password_confirmation).to be_nil
      end
    end
  end
end
