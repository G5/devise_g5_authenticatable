require 'spec_helper'

describe 'G5 Auth' do
  describe 'routing' do
    it 'should route GET /users/auth/g5' do
      expect(get '/users/auth/g5').to route_to(controller: 'devise/omniauth_callbacks',
                                               action: 'passthru')
    end

    it 'should route POST /users/auth/g5' do
      expect(post '/users/auth/g5').to route_to(controller: 'devise/omniauth_callbacks',
                                                action: 'passthru')
    end

    it 'should route GET /registered/admins/auth/g5' do
      expect(get '/registered/admins/auth/g5').to route_to(controller: 'devise/omniauth_callbacks',
                                                           action: 'passthru')
    end

    it 'should route POST /registered/admins/auth/g5' do
      expect(post '/registered/admins/auth/g5').to route_to(controller: 'devise/omniauth_callbacks',
                                                           action: 'passthru')
    end

    it 'should route GET /users/auth/g5/callback' do
      expect(get '/users/auth/g5/callback').to route_to(controller: 'devise/omniauth_callbacks',
                                                        action: 'g5')
    end

    it 'should route POST /users/auth/g5/callback' do
      expect(post '/users/auth/g5/callback').to route_to(controller: 'devise/omniauth_callbacks',
                                                         action: 'g5')
    end

    it 'should route GET /registered/admins/auth/g5/callback' do
      expect(get '/registered/admins/auth/g5/callback').to route_to(controller: 'devise/omniauth_callbacks',
                                                                    action: 'g5')
    end

    it 'should route POST /registered/admins/auth/g5/callback' do
      expect(post '/registered/admins/auth/g5/callback').to route_to(controller: 'devise/omniauth_callbacks',
                                                                     action: 'g5')
    end
  end

  describe 'url helpers' do
    it 'should generate user_g5_authorize_path' do
      expect(user_g5_authorize_path).to eq('/users/auth/g5')
    end

    it 'should generate user_g5_callback_path' do
      expect(user_g5_callback_path).to eq('/users/auth/g5/callback')
    end

    it 'should generate admin_g5_authorize_path' do
      expect(admin_g5_authorize_path).to eq('/registered/admins/auth/g5')
    end

    it 'should generate admin_g5_callback_path' do
      expect(admin_g5_callback_path).to eq('/registered/admins/auth/g5/callback')
    end
  end
end
