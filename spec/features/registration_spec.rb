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

    it 'should redirect to the root path' do
      register_user
      expect(current_path).to eq(root_path)
    end
  end

  context 'when password does not match confirmation' do
    let(:password_confirmation) { 'something else entirely' }

    it 'should not create a user' do
      expect { register_user }.to_not change { User.count }
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

    it 'should display an error message' do
      register_user
      expect(page).to have_content('Email has already been taken')
    end
  end
end
