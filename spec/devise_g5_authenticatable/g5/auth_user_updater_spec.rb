require 'spec_helper'

describe Devise::G5::AuthUserUpdater do
  let(:updater) { described_class.new }

  let(:auth_client) { double(:g5_authentication_client, update_user: auth_user) }
  let(:auth_user) { double(:auth_user, id: model.uid, email: model.email) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  let(:model) { create(:user, updated_by: updated_by) }
  let(:updated_by) {}

  describe '#update' do
    subject(:update) { updater.update(model) }

    context 'when email and password are unchanged' do
      before { model.password = nil }

      it 'should not update the auth service' do
        expect(auth_client).to_not receive(:update_user)
        update
      end

      it 'should not reset the password' do
        expect { update }.to_not change { model.password }
      end

      it 'should not reset the password_confirmation' do
        expect { update }.to_not change { model.password_confirmation }
      end
    end

    context 'when email has changed' do
      before { model.email = updated_email }

      let(:updated_email) { 'updated.email@test.host' }

      context 'when user has been updated by another user' do
        let(:updated_by) { create(:user) }

        context 'when auth user update is successful' do
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

          it 'should reset the password' do
            update
            expect(model.password).to be_nil
          end

          it 'should reset the password confirmation' do
            update
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
        it 'should use the user token to call g5 auth' do
          expect(G5AuthenticationClient::Client).to receive(:new).
            with(access_token: model.g5_access_token)
          update
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

      it 'should reset the password' do
        expect { update }.to change { model.password }.to(nil)
      end

      it 'should reset the password confirmation' do
        expect { update }.to change { model.password_confirmation }.to(nil)
      end
    end
  end
end
