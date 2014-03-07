require 'spec_helper'

describe G5::UserExporter do
  let(:exporter) { G5::UserExporter.new(options) }

  let(:options) do
    {client_id: 'my_client_id',
     client_secret: 'soopersekrit',
     redirect_uri: 'https://app.host/my/callback',
     endpoint: 'https://auth.host',
     authorization_code: 'abc123'}
  end

  describe '#export' do
    subject(:export) { exporter.export }

    let(:uid) { 'abc123yabbadabbadoo' }
    let(:email) { 'fred@flintstone.com' }
    let(:encrypted_password) { 'asdfklja;jtiohtsdgnmesmdnfsmdnfweurth34t' }

    let(:local_user) do
      double(:local_user, :id => 42,
                          :email => email,
                          :encrypted_password => encrypted_password,
                          :uid= => nil,
                          :provider= => nil,
                          :save => true)
    end
    before { allow(User).to receive(:all).and_return([local_user]) }

    let(:auth_user) { double(:auth_user, id: uid, email: email) }
    let(:auth_client) { double(:auth_client, create_user: auth_user) }
    before do
      allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
    end

    it 'should initialize the auth client with the correct client_id' do
      expect(G5AuthenticationClient::Client).to receive(:new).
        with(hash_including(client_id: options[:client_id])).
        and_return(auth_client)
      export
    end

    it 'should initialize the auth client with the correct client_secret' do
      expect(G5AuthenticationClient::Client).to receive(:new).
        with(hash_including(client_secret: options[:client_secret])).
        and_return(auth_client)
      export
    end

    it 'should initialize the auth client with the correct redirect_uri' do
      expect(G5AuthenticationClient::Client).to receive(:new).
        with(hash_including(redirect_uri: options[:redirect_uri])).
        and_return(auth_client)
      export
    end

    it 'should initialize the auth client with the correct endpoint' do
      expect(G5AuthenticationClient::Client).to receive(:new).
        with(hash_including(endpoint: options[:endpoint])).
        and_return(auth_client)
      export
    end

    it 'should initialize the auth client with the correct authorization code' do
      expect(G5AuthenticationClient::Client).to receive(:new).
        with(hash_including(authorization_code: options[:authorization_code])).
        and_return(auth_client)
      export
    end

    it 'should create the auth user with the correct email' do
      expect(auth_client).to receive(:create_user).
        with(hash_including(email: email)).
        and_return(auth_user)
      export
    end

    it 'should create the auth user with the correct default password' do
      expect(auth_client).to receive(:create_user).
        with(hash_including(password: encrypted_password)).
        and_return(auth_user)
      export
    end

    it 'should set the uid on the local user' do
      expect(local_user).to receive(:uid=).with(uid)
      export
    end

    it 'should set the provider on the local user' do
      expect(local_user).to receive(:provider=).with('g5')
      export
    end

    it 'should save the local user' do
      expect(local_user).to receive(:save).and_return(true)
      export
    end

    it 'should return the SQL update statement with the encrypted password' do
      expect(export).to match(/update users set encrypted_password='#{encrypted_password}' where id=#{uid};/i)
    end
  end
end
