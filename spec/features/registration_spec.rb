require 'spec_helper'

describe 'User registration' do
  subject(:register_user) { click_button 'Sign up' }

  before do
    visit new_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
  end

  let(:email) { 'fred.rogers@theneighborhood.net' }
  let(:password) { 'wontyoubemyneighbor' }
  let(:password_confirmation) { password }

  context 'when registration is valid' do
    it 'should create a user' do
      expect { register_user }.to change { User.count }.by(1)
    end

    it 'should display a success message' do
      register_user
      expect(page).to have_content('success')
    end
  end

  context 'when password does not match confirmation' do
    let(:password_confirmation) { 'something else entirely' }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
    end

    it 'should display an error message' do
      register_user
      # TODO: test for more specific error message
      expect(page).to have_content('error')
    end
  end

  context 'when email is blank' do
    let(:email) { '' }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
    end

    it 'should display an error message' do
      register_user
      # TODO: test for more specific error message
      expect(page).to have_content('error')
    end
  end

  context 'when email is not unique' do
    let(:user) { create(:user) }
    let(:email) { user.email }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
    end

    it 'should display an error message' do
      register_user
      # TODO: test for more specific error message
      expect(page).to have_content('error')
    end
  end
end
