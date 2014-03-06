require 'spec_helper'

describe 'g5:export_users' do
  include_context 'rake'

  let(:user_exporter) { double(:user_exporter, export: nil) }
  before { allow(G5::UserExporter).to receive(:new).and_return(user_exporter) }

  before { ENV['G5_AUTH_CLIENT_ID'] = default_client_id }
  let(:default_client_id) { 'default_client_id' }

  before { ENV['G5_AUTH_CLIENT_SECRET'] = default_client_secret }
  let(:default_client_secret) { 'default_client_secret' }

  before { ENV['G5_AUTH_REDIRECT_URI'] = default_redirect_uri }
  let(:default_redirect_uri) { 'http://test.host/default' }

  before { ENV['G5_AUTH_ENDPOINT'] = default_endpoint }
  let(:default_endpoint) { 'https://my.g5auth.host' }

  before { ENV['G5_AUTH_AUTHORIZATION_CODE'] = default_auth_code }
  let(:default_auth_code) { 'default_auth_code' }

  def expect_init_user_exporter_with(option_name, expected_value)
    expect(G5::UserExporter).to receive(:new) do |args|
      expect(args[option_name]).to eq(expected_value)
      user_exporter
    end
  end

  it 'should use the default authorization code from the environment' do
    expect_init_user_exporter_with(:authorization_code, default_auth_code)
    task.invoke
  end

  it 'should allow the default authorization code to be overridden by an argument' do
    auth_code_arg = 'some new auth code'
    expect_init_user_exporter_with(:authorization_code, auth_code_arg)
    task.invoke(auth_code_arg)
  end

  it 'should use the default client id from the environment' do
    expect_init_user_exporter_with(:client_id, default_client_id)
    task.invoke
  end

  it 'should allow the default client id to be overridden by an argument' do
    client_id_arg = 'custom_client_id_override'
    expect_init_user_exporter_with(:client_id, client_id_arg)
    task.invoke(nil, client_id_arg)
  end

  it 'should use the default client secret from the environment' do
    expect_init_user_exporter_with(:client_secret, default_client_secret)
    task.invoke
  end

  it 'should allow the default client secret to be overridden by an argument' do
    client_secret_arg = 'custom client secret'
    expect_init_user_exporter_with(:client_secret, client_secret_arg)
    task.invoke(nil, nil, client_secret_arg)
  end

  it 'should use the default redirect uri from the environment' do
    expect_init_user_exporter_with(:redirect_uri, default_redirect_uri)
    task.invoke
  end

  it 'should allow the default redirect uri to be overridden by an argument' do
    redirect_uri_arg = 'http://test.localhost/custom/callback'
    expect_init_user_exporter_with(:redirect_uri, redirect_uri_arg)
    task.invoke(nil, nil, nil, redirect_uri_arg)
  end

  it 'should use the default auth endpoint from the environment' do
    expect_init_user_exporter_with(:endpoint, default_endpoint)
    task.invoke
  end

  it 'should allow the default auth endpoint to be overridden by an argument' do
    endpoint_arg = 'https://custom-arg.auth.host'
    expect_init_user_exporter_with(:endpoint, endpoint_arg)
    task.invoke(nil, nil, nil, nil, endpoint_arg)
  end

  it 'should export the users' do
    expect(user_exporter).to receive(:export)
    task.invoke
  end
end
