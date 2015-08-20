require 'spec_helper'

describe G5::UserSynchronizer do
  let(:user_sync) { G5::UserSynchronizer.new(options) }

  let(:options) do
    {endpoint: 'https://test.auth.endpoint',
     client_id: 'test-client-id',
     client_secret: 'test-client-secret',
     username: 'test-username',
     password: 'test-password'}
  end

  let(:mock_auth_client) { double(:g5_authentication_client) }
  before { allow(G5AuthenticationClient::Client).to receive(:new).and_return(mock_auth_client) }

  describe '#sync_uids' do
    subject(:sync_uids) { user_sync.sync_uids }

    let(:local_user) do
      stub_model(User, email: email,
                       uid: '42',
                       provider: 'g5')
    end
    let(:email) { 'test.user@test.host' }
    before do
      allow(local_user).to receive(:save!).and_return(true)
      allow(User).to receive(:all).and_return([local_user])
    end

    context 'when auth user with matching email exists' do
      let(:auth_user) do
        double(:auth_user, email: email,
                           id: '99')
      end
      before do
        allow(mock_auth_client).to receive(:find_user_by_email).and_return(auth_user)
      end

      it 'should look up the auth user by email' do
        sync_uids
        expect(mock_auth_client).to have_received(:find_user_by_email).with(email)
      end

      it 'should set the local user uid' do
        sync_uids
        expect(local_user.uid).to eq(auth_user.id)
      end

      it 'should set the local user provider' do
        sync_uids
        expect(local_user.provider).to eq('g5')
      end

      it 'should save the local user' do
        sync_uids
        expect(local_user).to have_received(:save!)
      end
    end

    context 'when user with matching email does not exist' do
      before do
        allow(mock_auth_client).to receive(:find_user_by_email).and_return(nil)
      end

      it 'should look up the auth user by email' do
        sync_uids
        expect(mock_auth_client).to have_received(:find_user_by_email).with(email)
      end

      it 'should reset the local user uid' do
        sync_uids
        expect(local_user.uid).to eq(nil)
      end

      it 'should reset the local user provider' do
        sync_uids
        expect(local_user.provider).to eq(nil)
      end

      it 'should save the local user' do
        sync_uids
        expect(local_user).to have_received(:save!)
      end
    end
  end

  describe '#auth_client' do
    subject(:auth_client) { user_sync.auth_client }

    it 'returns the initialized auth client instance' do
      expect(auth_client).to eq(mock_auth_client)
    end

    it 'initializes the auth client with the endpoint' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).
        with(hash_including(endpoint: options[:endpoint]))
    end

    it 'initializes the auth client with the client_id' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).
        with(hash_including(client_id: options[:client_id]))
    end

    it 'initializes the auth client with the client_secret' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).
        with(hash_including(client_secret: options[:client_secret]))
    end

    it 'initializes the auth client with the username' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).
        with(hash_including(username: options[:username]))
    end

    it 'initializes the auth client with the password' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).
        with(hash_including(password: options[:password]))
    end

    it 'initializes the auth client with allow_password_credentials' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).
        with(hash_including(allow_password_credentials: true))
    end
  end
end
