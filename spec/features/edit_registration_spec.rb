require 'spec_helper'

describe 'Editing a user registration' do
  subject(:update_user) { click_button 'Update' }

  let(:user) { create(:user) }

  let(:auth_client) { double(:auth_client, update_user: auth_user, me: auth_user) }

  let(:auth_user) { double(:auth_user, id: user.uid, email: user.email) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(auth_client)
  end

  before do
    visit_path_and_login_with(edit_user_registration_path(user), user)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    fill_in 'Current password', with: current_password
  end

  let(:email) { 'new.email@test.host' }
  let(:password) { '' }
  let(:password_confirmation) { password }
  let(:current_password) { user.password }

  context 'when current password is valid' do
    context 'when password is blank' do
      it 'should update the email locally' do
        update_user
        user.reload
        expect(user.email).to eq(email)
      end

      it 'should update the email on the auth server' do
        expect(auth_client).to receive(:update_user).with({id: user.uid, email: email})
        update_user
      end
    end

    context 'when password is updated' do
      let(:password) { 'a brand new password' }

      it 'should update the password on the auth server' do
        expect(auth_client).to receive(:update_user).with({id: user.uid,
                                                           email: email,
                                                           password: password,
                                                           password_confirmation: password_confirmation})
        update_user
      end
    end

    context 'when email is blank' do
      let(:email) { '' }

      it 'should display an error message' do
        update_user
        expect(page).to have_content("Email can't be blank")
      end

      it 'should not update the credentials on the auth server' do
        expect(auth_client).to_not receive(:update_user)
        update_user
      end
    end

    context 'when the auth server returns an error' do
      include_context 'OAuth2::Error'

      it 'should display an error message' do
        update_user
        expect(page).to have_content(error_message)
      end

      it 'should not update the email locally' do
        update_user
        user.reload
        expect(user.email).to_not eq(email)
      end
    end
  end

  context 'when current password is invalid' do
    include_context 'OAuth2::Error'
    let(:error_message) { 'invalid_resource_owner' }
    before { allow(auth_client).to receive(:me).and_raise(oauth_error) }

    it 'should display an error message' do
      update_user
      expect(page).to have_content('Current password is invalid')
    end

    it 'should not update the credentials on the auth server' do
      expect(auth_client).to_not receive(:update_user)
      update_user
    end

    it 'should not update the email locally' do
      update_user
      user.reload
      expect(user.email).to_not eq(email)
    end
  end
end
