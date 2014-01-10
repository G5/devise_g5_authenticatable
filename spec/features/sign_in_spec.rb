require 'spec_helper'

describe 'Signing in' do
  context 'when visiting a protected page' do
    context 'with valid credentials' do
      context 'when user exists locally' do
        it 'should sign in the user successfully'
        it 'should redirect the user to the requested path'
        it 'should display name of the current user'
        it 'should display the email of the current user'
      end

      context 'when user does not exist locally' do
        it 'should redirect the user to the registration page'
        it 'should display an informative message'
        it 'should prefill the Email field'
      end
    end

    context 'with invalid credentials' do
      it 'should display an error'
    end
  end

  context 'when clicking a login link' do
    it 'should sign in the user successfully'
    it 'should redirect the user to the root path'
    it 'should display the name of the current user'
  end
end
