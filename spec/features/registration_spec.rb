require 'spec_helper'

describe 'User registration' do
  before do
    visit new_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
  end

  let(:email) { 'fred.rogers@theneighborhood.net' }
  let(:password) { 'wontyoubemyneighbor' }
  let(:password_confirmation) { password }

  it 'should display the sign up page' do
    expect(page).to have_content('Sign up')
  end
end
