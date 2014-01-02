require 'spec_helper'

describe 'User registration' do
  before do
    visit new_user_registration_path
  end

  it 'should display the sign up page' do
    expect(page).to have_content('Sign up')
  end
end
