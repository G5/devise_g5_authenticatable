require 'spec_helper'

describe 'Token validation per request' do
  let(:user) { create(:user) }
  let(:protected_path) { edit_user_registration_path }
  let(:token_info_url) { 'http://auth.g5search.com/oauth/token/info' }

  before do
    stub_request(:get, token_info_url).
      with(headers: {'Authorization'=>"Bearer #{user.g5_access_token}"}).
      to_return(status: 200, body: '', headers: {})
  end

  before do
    visit_path_and_login_with(protected_path, user)

    # Now that we're logged in, any subsequent attempts to
    # authenticate with the auth server will trigger an omniauth
    # failure, which is a condition we can test for
    stub_g5_invalid_credentials
  end

  context 'when token validation is disabled' do
    before do
      Devise.g5_strict_token_validation = false
      visit protected_path
    end

    it 'should not valid the token against the auth server' do
      expect(a_request(:get, token_info_url)).to_not have_been_made
    end

    it 'should allow the user to access the protected page' do
      expect(current_path).to eq(protected_path)
    end
  end

  context 'when token validation is enabled' do
    before { Devise.g5_strict_token_validation = true }

    context 'when the access_token is valid' do
      before { visit protected_path }

      it 'should validate the token against the auth server' do
        expect(a_request(:get, token_info_url).
               with(headers: {'Authorization' => "Bearer #{user.g5_access_token}"})).to have_been_made
      end

      it 'should allow the user to access the protected page' do
        expect(current_path).to eq(protected_path)
      end
    end

    context 'when the access_token has been invalidated' do
      before do
        stub_request(:get, token_info_url).
          with(headers: {'Authorization'=>"Bearer #{user.g5_access_token}"}).
          to_return(status: 401,
                    headers: {'Content-Type' => 'application/json; charset=utf-8',
                              'Cache-Control' => 'no-cache'},
                    body: {'error' => 'invalid_token',
                           'error_description' => 'The access token expired'}.to_json)
        visit protected_path
      end

      it 'should force the user to re-authenticate' do
        expect(page).to have_content('Invalid credentials')
      end
    end

    context 'when there is some other error from the auth server' do
      before do
        stub_request(:get, token_info_url).to_raise(StandardError)
        visit protected_path
      end

      it 'should force the user to re-authenticate' do
        expect(page).to have_content('Invalid credentials')
      end
    end
  end
end
