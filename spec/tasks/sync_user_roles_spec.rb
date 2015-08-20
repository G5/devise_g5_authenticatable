require 'spec_helper'

describe 'g5:sync_user_roles' do
  include_context 'rake'

  let(:default_endpoint) { 'https://my.auth.endpoint' }
  before { stub_env_var('G5_AUTH_ENDPOINT', default_endpoint) }

  let(:default_client_id) { 'my-auth-client-id' }
  before { stub_env_var('G5_AUTH_CLIENT_ID', default_client_id) }

  let(:default_client_secret) { 'my-auth-client-secret' }
  before { stub_env_var('G5_AUTH_CLIENT_SECRET', default_client_secret) }

  let(:default_username) { 'my_user@test.host' }
  before { stub_env_var('G5_AUTH_USERNAME', default_username) }

  let(:default_password) { 'my_secret' }
  before { stub_env_var('G5_AUTH_PASSWORD', default_password) }

  let(:user_sync) { double(:user_synchronizer, sync_roles: true) }
  before { allow(G5::UserSynchronizer).to receive(:new).and_return(user_sync) }

  context 'without arguments' do
    before { task.invoke }

    it 'initializes the user synchronizer with the default endpoint' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(endpoint: default_endpoint))
    end

    it 'initializes the user synchronizer with the default client_id' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(client_id: default_client_id))
    end

    it 'initializes the user synchronizer with the default client_secret' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(client_secret: default_client_secret))
    end

    it 'initializes the user synchronizer with the default username' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(username: default_username))
    end

    it 'initializes the user synchronizer with the default password' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(password: default_password))
    end

    it 'executes the action to sync user roles' do
      expect(user_sync).to have_received(:sync_roles)
    end
  end

  context 'with arguments' do
    before do
      task.invoke(username_arg, password_arg, client_id_arg, client_secret_arg,
                  endpoint_arg)
    end

    let(:client_id_arg) { 'non-default-client-id' }
    let(:client_secret_arg) { 'non-default-client-secret' }
    let(:username_arg) { 'non-default-username' }
    let(:password_arg) { 'non-default-password' }
    let(:endpoint_arg) { 'non-default-endpoint' }

    it 'initializes the user synchronizer with the username argument' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(username: username_arg))
    end

    it 'initializes the user synchronizer with the client_id argument' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(client_id: client_id_arg))
    end

    it 'initializes the user synchronizer with the client_secret argument' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(client_secret: client_secret_arg))
    end

    it 'initializes the user synchronizer with the password argument' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(password: password_arg))
    end

    it 'initializes the user synchronizer with the endpoint argument' do
      expect(G5::UserSynchronizer).to have_received(:new).
        with(hash_including(endpoint: endpoint_arg))
    end

    it 'executes the action to sync user uids' do
      expect(user_sync).to have_received(:sync_roles)
    end
  end
end
