require 'spec_helper'

describe 'Signing in' do
  context 'when visiting a protected page' do
    let(:protected_path) { edit_user_registration_path }

    context 'with valid credentials' do
      before do
        stub_g5_omniauth(user)
        visit protected_path
      end

      context 'when user exists locally' do
        let(:user) { create(:user) }

        it 'should sign in the user successfully' do
          expect(page).to have_content('Signed in successfully.')
        end

        it 'should redirect the user to the requested path' do
          expect(current_path).to eq(protected_path)
        end
      end

      context 'when user does not exist locally' do
        let(:user) { build(:user) }

        it 'should display an informative message' do
          expect(page).to have_content('You must sign up before continuing.')
        end

        it 'should redirect the user to the registration page' do
          expect(current_path).to eq(new_user_registration_path)
        end

        it 'should prefill the Email field' do
          expect(find_field('Email').value).to eq(user.email)
        end
      end
    end

    context 'with invalid credentials' do
      before do
        stub_g5_invalid_credentials
        visit protected_path
      end

      let(:user) { create(:user) }

      it 'should display an error' do
        expect(page).to have_content('Invalid credentials')
      end
    end
  end

  context 'when clicking a login link' do
    before do
      visit root_path
      stub_g5_omniauth(user)
      click_link 'Login'
    end

    let(:user) { create(:user) }

    it 'should sign in the user successfully' do
      expect(page).to have_content('Signed in successfully.')
    end

    it 'should redirect the user to the root path' do
      expect(current_path).to eq(root_path)
    end
  end

  context 'when clicking a login link after signing in' do
    before do
      visit_path_and_login_with(edit_user_registration_path, user)
      visit root_path
      click_link 'Login'
    end

    let(:user) { create(:user) }

    it 'should warn the user that they are currently signed in' do
      expect(page).to have_content('You are already signed in.')
    end

    it 'should redirect the user to the root path' do
      expect(current_path).to eq(root_path)
    end
  end
end
