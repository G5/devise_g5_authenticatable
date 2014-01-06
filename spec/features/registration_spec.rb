require 'spec_helper'

describe 'User registration' do
  subject(:register_user) { click_button 'Sign up' }

  let(:auth_client) { double(:auth_client, create_user: auth_user) }
  let(:auth_user) { double(:auth_user, id: uid, email: email) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  before do
    visit new_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
  end

  let(:email) { 'fred.rogers@theneighborhood.net' }
  let(:password) { 'wontyoubemyneighbor' }
  let(:password_confirmation) { password }
  let(:uid) { '42-remote-uid' }

  context 'when registration is valid' do
    it 'should create a user' do
      expect { register_user }.to change { User.count }.by(1)
    end

    it 'should redirect to the root path' do
      register_user
      expect(current_path).to eq(root_path)
    end

    it 'should create the user on the auth server' do
      expect(auth_client).to receive(:create_user).
        with({email: email,
              password: password,
              password_confirmation: password_confirmation}).
        and_return(auth_user)
      register_user
    end

    it 'needs a token from somewhere - figure it out'

    it 'should assign the provider and uid to the user' do
      register_user
      user = User.find_by_email(email)
      expect(user.provider).to eq('g5')
      expect(user.uid).to eq(uid)
    end
  end

  context 'when there is an error on the auth server' do
    include_context 'OAuth2::Error'
    before { allow(auth_client).to receive(:create_user).and_raise(oauth_error) }

    it 'should display an error message' do
      register_user
      expect(page).to have_content(error_message)
    end

    it 'should not create the user locally' do
      expect { register_user }.to_not change { User.count }
    end
  end

  context 'when password does not match confirmation' do
    let(:password_confirmation) { 'something else entirely' }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
    end

    it 'should not create a user on the auth server' do
      expect(auth_client).to_not receive(:create_user)
      register_user
    end

    it 'should display an error message' do
      register_user
      expect(page).to have_content("Password doesn't match confirmation")
    end
  end

  context 'when email is blank' do
    let(:email) { '' }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
    end

    it 'should not create a user on the auth server' do
      expect(auth_client).to_not receive(:create_user)
      register_user
    end

    it 'should display an error message' do
      register_user
      expect(page).to have_content("Email can't be blank")
    end
  end

  context 'when email is not unique' do
    let(:user) { create(:user) }
    let(:email) { user.email }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
    end

    it 'should not create a user on the auth server' do
      expect(auth_client).to_not receive(:create_user)
      register_user
    end

    it 'should display an error message' do
      register_user
      expect(page).to have_content('Email has already been taken')
    end
  end
end
