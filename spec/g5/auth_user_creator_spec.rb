# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::G5::AuthUserCreator do
  let(:creator) { described_class.new(model) }

  describe '#create' do
    subject(:create) { creator.create }

    let(:model) do
      build_stubbed(:user, password: password,
                           password_confirmation: password_confirmation,
                           updated_by: updated_by)
    end

    let(:updated_by) {}
    let(:password) { 'new password' }
    let(:password_confirmation) { 'new password confirmation' }
    let(:other_password) { 'blah' }

    let(:auth_client) { double(:g5_authentication_client) }

    let(:auth_user) do
      double(:auth_user, id: uid,
                         email: model.email,
                         password: other_password,
                         clean_up_passwords: nil,
                         to_hash: {})
    end

    let(:uid) { 'remote-auth-user-42' }

    before do
      allow(G5AuthenticationClient::Client).to receive(:new)
        .and_return(auth_client)
    end

    context 'when there is an existing auth user' do
      before do
        model.uid = nil
        allow(auth_client).to receive(:create_user)
          .and_raise(StandardError, 'Email has already been taken')
        allow(auth_client).to receive(:find_user_by_email).and_return(auth_user)
        allow(auth_client).to receive(:update_user)
      end

      it 'should create the local user with the existing uid' do
        allow(auth_user).to receive(:password=)
        allow(auth_user).to receive(:password_confirmation=)
        expect { create }.to change { model.uid }.to(uid)
      end

      it 'should reset the password' do
        expect(auth_user).to receive(:password=).with(password)
        expect(auth_user).to receive(:password_confirmation=).with(password)
        create
      end
    end

    context 'when there is no existing auth user' do
      before do
        allow(auth_client).to receive(:create_user).and_return(auth_user)
      end

      context 'when the new model has no uid' do
        before { model.uid = nil }

        context 'when updated by an existing user' do
          let(:updated_by) { build_stubbed(:user) }

          before { create }

          it 'should use the token for updated_by user to call g5 auth' do
            expect(G5AuthenticationClient::Client).to have_received(:new)
              .with(access_token: updated_by.g5_access_token)
          end

          it 'should create a new auth user with the correct email' do
            expect(auth_client).to have_received(:create_user)
              .with(hash_including(email: model.email))
          end

          context 'when password is set on model' do
            it 'should create a new auth user with the correct password' do
              expect(auth_client).to have_received(:create_user)
                .with(hash_including(password: password))
            end

            it 'creates a new auth user with the correct password confirmation' do
              expect(auth_client).to have_received(:create_user)
                .with(
                  hash_including(password_confirmation: password_confirmation)
                )
            end

            it 'should reset the password' do
              expect(model.password).to be_nil
            end

            it 'should reset the password_confirmation' do
              expect(model.password_confirmation).to be_nil
            end
          end

          context 'when password is not set on model' do
            let(:password) { '' }
            let(:password_confirmation) { '' }

            it 'creates a new auth user with randomly generated non-blank password' do
              expect(auth_client).to have_received(:create_user)
                .with(hash_including(password: /\w+/))
            end

            it 'creates a new auth user with non-blank password_confirmation' do
              expect(auth_client).to have_received(:create_user)
                .with(hash_including(password: /\w+/))
            end

            it 'resets the password' do
              expect(model.password).to be_nil
            end

            it 'resets the password_confirmation' do
              expect(model.password_confirmation).to be_nil
            end
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
          before { create }

          it 'should use the user token to call g5 auth' do
            expect(G5AuthenticationClient::Client).to have_received(:new)
              .with(access_token: model.g5_access_token)
          end
        end
      end

      context 'when new model already has a uid' do
        before { model.uid = 'remote-user-42' }
        before { create }

        it 'should not create a user' do
          expect(auth_client).to_not have_received(:create_user)
        end

        it 'should not reset the password' do
          expect(model.password).to_not be_blank
        end

        it 'should not reset the password_confirmation' do
          expect(model.password_confirmation).to_not be_blank
        end
      end
    end
  end
end
