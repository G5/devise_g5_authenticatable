# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions controller' do
  describe 'routing' do
    context 'with user scope' do
      it 'should route GET /users/sign_in' do
        expect(get('/users/sign_in'))
          .to route_to(controller: 'devise_g5_authenticatable/sessions',
                       action: 'new')
      end

      it 'should route DELETE /users/sign_out' do
        expect(delete('/users/sign_out'))
          .to route_to(controller: 'devise_g5_authenticatable/sessions',
                       action: 'destroy')
      end

      it 'should route GET /users/auth/g5' do
        expect(get('/users/auth/g5'))
          .to route_to(controller: 'devise_g5_authenticatable/sessions',
                       action: 'omniauth_passthru')
      end

      it 'should route POST /users/auth/g5' do
        expect(post('/users/auth/g5'))
          .to route_to(controller: 'devise_g5_authenticatable/sessions',
                       action: 'omniauth_passthru')
      end

      it 'should route GET /users/auth/g5/callback' do
        expect(get('/users/auth/g5/callback'))
          .to route_to(controller: 'devise_g5_authenticatable/sessions',
                       action: 'create')
      end

      it 'should route POST /users/auth/g5/callback' do
        expect(post('/users/auth/g5/callback'))
          .to route_to(controller: 'devise_g5_authenticatable/sessions',
                       action: 'create')
      end

      it 'should set the OmniAuth path prefix' do
        expect(OmniAuth.config.path_prefix).to eq('/users/auth')
      end
    end

    context 'with admin scope' do
      it 'should route GET /registered/admins/custom_sign_in' do
        expect(get('/registered/admins/custom_sign_in'))
          .to route_to(controller: 'custom_sessions',
                       action: 'new')
      end

      it 'should route DELETE /registered/admins/custom_sign_out' do
        expect(delete('/registered/admins/custom_sign_out'))
          .to route_to(controller: 'custom_sessions',
                       action: 'destroy')
      end

      it 'should route GET /registered/admins/auth/g5' do
        expect(get('/registered/admins/auth/g5'))
          .to route_to(controller: 'custom_sessions',
                       action: 'omniauth_passthru')
      end

      it 'should route POST /registered/admins/auth/g5' do
        expect(post('/registered/admins/auth/g5'))
          .to route_to(controller: 'custom_sessions',
                       action: 'omniauth_passthru')
      end

      it 'should route GET /registered/admins/auth/g5/callback' do
        expect(get('/registered/admins/auth/g5/callback'))
          .to route_to(controller: 'custom_sessions',
                       action: 'create')
      end

      it 'should route POST /registered/admins/auth/g5/callback' do
        expect(post('/registered/admins/auth/g5/callback'))
          .to route_to(controller: 'custom_sessions',
                       action: 'create')
      end
    end
  end

  describe 'generated url helpers' do
    context 'with user scope' do
      it 'should generate new_user_session_path' do
        expect(new_user_session_path).to eq('/users/sign_in')
      end

      it 'should generate destroy_user_session_path' do
        expect(destroy_user_session_path).to eq('/users/sign_out')
      end

      it 'should generate user_g5_authorize_path' do
        expect(user_g5_authorize_path).to eq('/users/auth/g5')
      end

      it 'should generate user_g5_callback_path' do
        expect(user_g5_callback_path).to eq('/users/auth/g5/callback')
      end
    end

    context 'with admin scope' do
      it 'should route new_admin_session_path' do
        expect(new_admin_session_path)
          .to eq('/registered/admins/custom_sign_in')
      end

      it 'should route destroy_admin_session_path' do
        expect(destroy_admin_session_path)
          .to eq('/registered/admins/custom_sign_out')
      end

      it 'should generate admin_g5_authorize_path' do
        expect(admin_g5_authorize_path).to eq('/registered/admins/auth/g5')
      end

      it 'should generate admin_g5_callback_path' do
        expect(admin_g5_callback_path)
          .to eq('/registered/admins/auth/g5/callback')
      end
    end
  end
end
