# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviseG5Authenticatable::SessionsController do
  before { request.env['devise.mapping'] = Devise.mappings[scope] }
  let(:scope) { :user }

  describe '#new' do
    subject(:new_session) { get(:new) }

    context 'with user scope' do
      it 'should redirect to the scoped authorize path' do
        expect(new_session).to redirect_to(user_g5_authorize_path)
      end
    end

    context 'with admin scope' do
      let(:scope) { :admin }

      it 'should redirect to the scoped authorize path' do
        expect(new_session).to redirect_to(admin_g5_authorize_path)
      end
    end
  end

  describe '#omniauth_passthru' do
    subject(:passthru) { get(:omniauth_passthru) }

    it 'should return a 404' do
      expect(passthru).to be_not_found
    end
  end

  describe '#create' do
    subject(:create_session) { post(:create) }

    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: 'g5',
        uid: '45',
        info: { name: 'Foo Bar',
                email: 'foo@bar.com' },
        credentials: { token: 'abc123' },
        extra: {
          raw_info: {
            accessible_applications: ['global'],
            restricted_application_redirect_url: 'https://imc.com'
          }
        }
      )
    end
    before { request.env['omniauth.auth'] = auth_hash }

    context 'when local model exists' do
      let(:model) do
        stub_model(model_class,
                   provider: auth_hash.provider,
                   uid: auth_hash.uid,
                   email: auth_hash.email,
                   g5_access_token: auth_hash.credentials.token,
                   save!: true,
                   update_g5_credentials: true,
                   email_changed?: false)
      end
      before do
        allow(model_class).to receive(:find_and_update_for_g5_oauth)
          .and_return(model)
      end

      context 'with user scope' do
        let(:model_class) { User }
        let(:scope) { :user }

        it 'should find the user and update the oauth credentials' do
          create_session
          expect(User).to have_received(:find_and_update_for_g5_oauth)
            .with(auth_hash)
        end

        it 'should set the flash message' do
          create_session
          expect(flash[:notice]).to eq('Signed in successfully.')
        end

        it 'should sign in the user' do
          expect { create_session }.to change { controller.current_user }
            .from(nil).to(model)
        end

        it 'should redirect the user' do
          create_session
          expect(response).to be_a_redirect
        end
      end

      context 'with admin scope' do
        let(:model_class) { Admin }
        let(:scope) { :admin }

        it 'should find the admin and update the oauth credentials' do
          create_session
          expect(Admin).to have_received(:find_and_update_for_g5_oauth)
            .with(auth_hash)
        end

        it 'should sign in the admin' do
          expect { create_session }.to change { controller.current_admin }
            .from(nil).to(model)
        end
      end
    end

    context 'when local model does not exist' do
      before do
        allow(model_class).to receive(:find_and_update_for_g5_oauth)
          .and_return(nil)
      end

      context 'with user scope' do
        let(:scope) { :user }
        let(:model_class) { User }

        it 'should set the flash message' do
          create_session
          expect(flash[:alert]).to eq('You must sign up before continuing.')
        end

        it 'should not sign in a user' do
          expect { create_session }.to_not change { controller.current_user }
        end

        it 'should redirect to the user registration path' do
          expect(create_session).to redirect_to(new_user_registration_path)
        end

        it 'should set the auth data on the session' do
          expect { create_session }.to change { session['omniauth.auth'] }
            .to(auth_hash)
        end
      end

      context 'with admin scope' do
        let(:scope) { :admin }
        let(:model_class) { Admin }

        it 'should redirect to the admin registration path' do
          expect(create_session).to redirect_to(new_admin_registration_path)
        end

        it 'should set the auth data on the session' do
          expect { create_session }.to change { session['omniauth.auth'] }
            .to(auth_hash)
        end
      end
    end

    context 'when user does not have access to application' do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          provider: 'g5',
          uid: '45',
          info: { name: 'Foo Bar',
                  email: 'foo@bar.com' },
          credentials: { token: 'abc123' },
          extra: {
            raw_info: {
              accessible_applications: [],
              restricted_application_redirect_url: 'https://imc.com'
            }
          }
        )
      end

      let(:model) do
        stub_model(model_class,
                   provider: auth_hash.provider,
                   uid: auth_hash.uid,
                   email: auth_hash.email,
                   g5_access_token: auth_hash.credentials.token,
                   save!: true,
                   update_g5_credentials: true,
                   email_changed?: false)
      end

      before do
        allow(model_class).to receive(:find_and_update_for_g5_oauth)
          .and_return(model)
      end

      let(:model_class) { User }
      let(:scope) { :user }

      it 'should redirect the user' do
        create_session
        expect(subject).to redirect_to(auth_hash.extra.raw_info.restricted_application_redirect_url)
      end
    end
  end

  describe '#destroy' do
    subject(:destroy_session) { delete(:destroy) }

    let(:auth_client) { double(:auth_client, sign_out_url: auth_sign_out_url) }
    let(:auth_sign_out_url) do
      'https://auth.test.host/sign_out?redirect_url=http%3A%2F%2Ftest.host%2F'
    end
    before do
      allow(G5AuthenticationClient::Client).to receive(:new)
        .and_return(auth_client)
    end

    let(:model) { create(scope) }
    before { allow(model).to receive(:revoke_g5_credentials!) }

    context 'with user scope' do
      let(:scope) { :user }

      context 'when there is a current user' do
        before { sign_in(model, scope: scope) }

        it 'should sign out the user locally' do
          expect { destroy_session }.to change { controller.current_user }
            .to(nil)
        end

        it 'should construct the sign out URL with the correct redirect URL' do
          expect(auth_client).to receive(:sign_out_url)
            .with(root_url)
            .and_return(auth_sign_out_url)
          destroy_session
        end

        it 'should redirect to the auth server to sign out globally' do
          expect(destroy_session).to redirect_to(auth_sign_out_url)
        end

        it 'should revoke the g5 access token' do
          expect(controller.current_user).to receive(:revoke_g5_credentials!)
          destroy_session
        end
      end

      context 'when there is not a current user' do
        it 'should redirect to the auth server to sign out globally' do
          expect(destroy_session).to redirect_to(auth_sign_out_url)
        end
      end
    end

    context 'with admin scope' do
      let(:scope) { :admin }

      before { sign_in(model, scope: scope) }

      it 'should sign out the admin locally' do
        expect { destroy_session }.to change { controller.current_admin }
          .to(nil)
      end

      it 'should revoke the g5 access token' do
        expect(controller.current_admin).to receive(:revoke_g5_credentials!)
        destroy_session
      end
    end
  end

  describe '#failure' do
    subject(:failure) do
      # We need some trickery here because the failure action is actually rack
      # rather than rails
      rack_response = described_class.action(:failure).call(request.env)
      @response = ActionDispatch::TestResponse.new(rack_response[0],
                                                   rack_response[1],
                                                   rack_response[2].body)
    end

    before do
      request.env['omniauth.error'] = error
      request.env['omniauth.error.strategy'] = omniauth_strategy
    end

    let(:omniauth_strategy) { double(:omniauth_strategy, name: 'G5') }

    context 'with error_reason' do
      let(:error) { double(:error, error_reason: reason) }
      let(:reason) { 'The error reason' }

      it 'should set the flash message' do
        failure
        expect(flash[:alert]).to eq(
          "Could not authenticate you from G5 because \"#{reason}\"."
        )
      end

      it 'should be a redirect' do
        failure
        expect(response).to be_a_redirect
      end

      it 'should redirect to root path' do
        failure
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with error string' do
      let(:error) { double(:error, error: message) }
      let(:message) { 'The error string' }

      it 'should set the flash message' do
        failure
        expect(flash[:alert]).to eq(
          "Could not authenticate you from G5 because \"#{message}\"."
        )
      end

      it 'should redirect to the root path' do
        expect(failure).to redirect_to(root_path)
      end
    end

    context 'with omniauth error type' do
      before { request.env['omniauth.error.type'] = :invalid_credentials }
      let(:humanized_type) { 'Invalid credentials' }
      let(:error) { Object.new }

      it 'should set the flash message' do
        failure
        expect(flash[:alert]).to eq(
          "Could not authenticate you from G5 because \"#{humanized_type}\"."
        )
      end

      it 'should redirect to the root path' do
        expect(failure).to redirect_to(root_path)
      end
    end
  end
end
