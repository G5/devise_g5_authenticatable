require 'spec_helper'

describe Devise::G5SessionsController do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#new' do
    subject(:get_new) { get :new }

    it 'should redirect to the g5 authorize path' do
      get_new
      expect(response).to redirect_to(user_g5_authorize_path)
    end
  end

  describe '#passthru' do
    subject(:passthru) { get :passthru }

    it 'should return a 404' do
      passthru
      expect(response).to be_not_found
    end
  end

  describe '#create' do
  end

  describe '#failure' do
  end

  describe '#destroy' do
    subject(:destroy_session) { delete :destroy }

    let(:auth_client) { double(:auth_client, sign_out_url: auth_sign_out_url) }
    let(:auth_sign_out_url) { 'https://auth.test.host/sign_out?redirect_url=http%3A%2F%2Ftest.host%2F' }
    before do
      allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
    end

    let(:user) { create(:user) }

    before do
      sign_in user
      allow(user).to receive(:revoke_g5_credentials!)
    end

    xit 'should sign out the user locally' do
      destroy_session
      expect(controller.current_user).to be_nil
    end

    xit 'should construct the sign out URL with the correct redirect URL' do
      expect(auth_client).to receive(:sign_out_url).
        with(root_url).
        and_return(auth_sign_out_url)
      destroy_session
    end

    xit 'should redirect to the auth server to sign out globally' do
      expect(destroy_session).to redirect_to(auth_sign_out_url)
    end

    xit 'should revoke the g5 access token' do
      expect(controller.current_user).to receive(:revoke_g5_credentials!)
      destroy_session
    end
  end
end
