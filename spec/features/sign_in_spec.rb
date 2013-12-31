require 'spec_helper'

describe 'Signing in' do
  before { visit new_user_session_path }

  it 'should contain the words sign in' do
    expect(page).to have_content('Sign in')
  end
end
