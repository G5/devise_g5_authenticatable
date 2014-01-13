require 'spec_helper'

describe 'Sessions controller' do
  describe 'routing' do
    it 'should route GET /users/sign_in' do
      expect(get '/users/sign_in').to route_to(controller: 'devise/sessions',
                                               action: 'new')
    end

    it 'should route DELETE /users/sign_out' do
      expect(delete '/users/sign_out').to route_to(controller: 'devise/sessions',
                                                   action: 'destroy')
    end

    it 'should route GET /admin_area/sign_in' do
      expect(get '/registered/admins/sign_in').to route_to(controller: 'custom_sessions',
                                                    action: 'new')
    end

    it 'should route GET /admin_area/sign_out' do
      expect(delete '/registered/admins/sign_out').to route_to(controller: 'custom_sessions',
                                                        action: 'destroy')
    end
  end

  describe 'url helpers' do
    it 'should route new_user_session_path' do
      expect(new_user_session_path).to eq('/users/sign_in')
    end

    it 'should route destroy_user_session_path' do
      expect(destroy_user_session_path).to eq('/users/sign_out')
    end

    it 'should route new_admin_session_path' do
      expect(new_admin_session_path).to eq('/registered/admins/sign_in')
    end

    it 'should route destroy_admin_session_path' do
      expect(destroy_admin_session_path).to eq('/registered/admins/sign_out')
    end
  end
end
