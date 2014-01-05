require 'spec_helper'

describe Devise::G5::AuthPasswordValidator do
  let(:validator) { described_class.new }

  describe '#valid_password?' do
    subject(:valid_password?) { validator.valid_password?(user, password) }

    let(:user) { build_stubbed(:user) }
    let(:password) { 'password to check' }

    let(:auth_client) { double(:g5_authentication_client, me: auth_user) }
    let(:auth_user) { double(:auth_user, uid: user.uid, email: user.email) }

    let(:oauth_error) { OAuth2::Error.new(response) }
    let(:response) { double(:oauth_response, parsed: oauth_error_hash).as_null_object }

    before do
      allow(G5AuthenticationClient::Client).to receive(:new).
        and_return(auth_client)
    end

    context 'with valid password' do
      it 'should initialize auth client with the username' do
        expect(G5AuthenticationClient::Client).to receive(:new).
          with(hash_including(username: user.email)).
          and_return(auth_client)
        valid_password?
      end

      it 'should initialize auth client with the password' do
        expect(G5AuthenticationClient::Client).to receive(:new).
          with(hash_including(password: password)).
          and_return(auth_client)
        valid_password?
      end

      it 'should retrieve the auth user associated with these credentials' do
        expect(auth_client).to receive(:me).and_return(auth_user)
        valid_password?
      end

      it 'should return true' do
        expect(valid_password?).to be_true
      end
    end

    context 'with invalid password' do
      before { allow(auth_client).to receive(:me).and_raise(oauth_error) }

      let(:oauth_error_hash) do
        {'error' => 'invalid_resource_owner',
         'error_description' => 'The provided resource owner credentials are not valid, or resource owner cannot be found.'}
      end

      it 'should return false' do
        expect(valid_password?).to be_false
      end
    end

    context 'with blank password' do
      before { allow(auth_client).to receive(:me).and_raise(runtime_error) }
      let(:runtime_error) { RuntimeError.new('Insufficient credentials for access token. Supply a username/password or authentication code.') }

      it 'should return false' do
        expect(valid_password?).to be_false
      end
    end

    context 'when an unrelated server error occurs' do
      before { allow(auth_client).to receive(:me).and_raise(oauth_error) }

      let(:oauth_error_hash) do
        {'error' => 'unauthorized_client',
         'error_description' => 'The client is not authorized to perform this request using this method.'}
      end

      it 'should re-raise the error' do
        expect { valid_password? }.to raise_error(oauth_error)
      end
    end
  end
end
